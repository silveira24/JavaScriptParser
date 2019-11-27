obj = { x, y }

let obj = {
    foo: "bar",
    [ "baz" + quux() ]: 42
}

var obj = {
    foo: "bar"
};
obj[ "baz" + quux() ] = 42;


obj = {
    foo (a, b) {
    },
    *quux (x, y) {
    }
}