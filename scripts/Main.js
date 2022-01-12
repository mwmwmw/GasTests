const RPS1 = require("./RPS");
const RPS2 = require("./RPS2");
const RPS3 = require("./RPS3");
const RPS4 = require("./RPS4");


async function Main() {


    await RPS1.main();
    await RPS2.main();
    await RPS3.main();
    await RPS4.main();


}

try {
    Main();
} catch (err) {
    console.log(err);
}