const RPS1 = require("./RPS");
const RPS64 = require("./RPS64");
const RPS64Out = require("./RPS64Out");
const RPS64Burn = require("./RPS64Burn");
const RPS2 = require("./RPS2");
const RPS3 = require("./RPS3");
const RPS4 = require("./RPS4");


async function Main() {

    await RPS1.main();
    await RPS64.main();
    await RPS64Out.main();
    await RPS64Burn.main();

    console.log("--- Simple Versions ---")

    await RPS2.main();
    await RPS3.main();
    await RPS4.main();

}

try {
    Main();
} catch (err) {
    console.log(err);
}