let target = {
    foo: "Welcome, foo"
};
let proxy = new Proxy(target, {
    get (receiver, name) {
        return name in receiver ? receiver[name] : 'Hello', ${name}
    }