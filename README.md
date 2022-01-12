# Read All The Things - A Smart Contract Design Philosophy

I often see smart contract developers lamenting about gas. However, to combat GAS usage, I see significant optimizations done to squeeze the most out of a routine while paying minimal gas.

But is this the only way to optimize? What if there was a way to pay no gas fees whatsoever? Dream On!

But what can we do to lower gas fees in our transactions?

## What uses GAS?

Changing the state of the blockchain and anything you do in service uses gas.

That's it. 

Once you start tinkering with the state of the blockchain, those changes will need to be validated. Validation = proof of work = GAS. 
  

## Ethereum.org says

>Gas refers to the unit that measures the amount of computational effort required to execute specific operations on the Ethereum network._ 

Hmm, pretty vague. It doesn't mention **storage** at all.


## What doesn't use GAS?
Everyone gets so torn up about gas that nobody wonders what __doesn't__ use gas. 

Reading from the blockchain does not use GAS.

Functions that are **view** or **pure** do not alter the state of the contract. Unless you use them in a function that changes the state of the blockchain, you won't pay GAS to use them.

### Maybe we can use this?


## Read all the things
So here is my initial assumption. 

Suppose computations and storage use GAS. Don't do anything to alter values that you can do later.

If reading is 'free,' then do all your alterations in view functions.

More succinctly,

>Don't do anything in a transaction that you can do in a view.

---


## Example 1 

```

function setValue(string a, string b) {

 myValue = abi.encodePacked(a, " ", b);

}

  

function getValue() view returns (string memory) {

 return myValue;

}

```

Simple enough, right? No big deal here. We're taking two strings, combining them. Done. The gas usage is affected by the length of the two strings taken as input;

  

#### Ok, how about now?

```

function setValue(string a, string b) {

 myValue = Base64.encode(abi.encodePacked(a, " ", b));

}

  

function getValue() view returns (string memory) {

 return myValue;

}

```

I can hear you now. "Oof! Don't do that!"

  

#### Why is this worse?

We're going to pay gas for the operation and the increased size of the string we store. There is no chance that the base64 encoded string will be smaller than the original.

We're creating MORE stuff to store, which will cost GAS.


#### Do this instead.

```

function setValue(string a, string b) {

 myValue = abi.encodePacked(a, " ", b);

}

  

function getValue() view returns (string memory) {

 return Base64.encode(myValue);

}

```

Phew! Now we can have our cake and eat it too.
The Base64 encoding is now 'free.'

---

## Example 2

I put all these contracts into a repo so that you can pull it and show me how wrong I am about everything. [Gas Tests](https://github.com/mwmwmw/GasTests)

This version of RPS has a `Play()` function that accepts two addresses then pits them against each other. Each game returns a JSON string with the player addresses and who won.

I tried to keep all the different versions roughly the same, and where I differed, I noted it below.

  

### Compute and store results on write

[Testing all work write function, store results](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors.sol)
Avg Gas Limit: **202970**
  
[Testing all work write function, store base64 encoded results](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors64.sol)
Avg Gas Limit: **258241**

[Testing all work write function, store results, base64 encode in output](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors64Out.sol)
Avg Gas Limit: **202971**

[Testing all work write function, store results, useless base64 encoding](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors64Burn.sol)
Avg Gas Limit: **213919**

I added this to demonstrate that stuff like Base64 encoding doesn't add much GAS. Base64ing only uses ~10K gas. Storage is the most significant portion of the cost.

---

  

### Store raw values, compute on read

[Some work in write function, some storage, compute output in read](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors2.sol)
Avg Gas Limit: **107094**

This one is smaller because the uint256 values are never larger than 2. So storing a full-sized number adds ~10000 gas. I was surprised by this.

> I had assumed that if you stored a uint256 value, any two values of that type would use the equivalent storage, but that is not the case!


[Only storage in write function, compute all output in read](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors3.sol)
Avg Gas Limit: **116836**

[Minimal storage and no work in write function, compute output in read](https://github.com/mwmwmw/GasTests/blob/master/contracts/RockPaperScissors4.sol)
Avg Gas Limit: **96017**

Note: I cheated for this one. It is not equivalent to the other functions because it calculates the RPS value differently. For this, I store a single seed from `block.difficulty` and `block.timestamp`. In all the other contracts, these are always separate. 

### Conclusion
So that is how it shakes out. Even in this very rudimentary example, you can cut your gas usage in HALF by storing small values and encoding on read. 

## Shrink all the things
After doing these tests, I altered my assumption.

> Don't do anything in a transaction that you can do in a view unless it will reduce the size of the stored values and the GAS used in the computation is less than the GAS used by storage.

Doesn't roll off the tongue as well. :/ But that's the truth!

## Fun Facts and Gotchas

1) You can move all of your view functions to a separate contract. As long as they do not alter the state of the blockchain, you will not pay any gas for the work done. (See #2 however)

2) If you call a view function/view contract within a transaction, you will pay gas for all the things. This strategy doesn't magically avoid GAS. 

3) Optimized computations don't add a lot to GAS. So use them to reduce the size of stored values if the cost to compute is lower than the cost to store them.

4) In these examples, stored values are the most significant contributor to gas.