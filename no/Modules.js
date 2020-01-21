export function sum (x, y) { return x + y }
export var pi = 3.141593

import * as math from "lib/math"
console.log("2π = " + math.sum(math.pi, math.pi))

import { sum, pi } from "lib/math"
console.log("2π = " + sum(pi, pi))

export * from "lib/math"
export var e = 2.71828182846
export default (x) => Math.exp(x)

import exp, { pi, e } from "lib/mathplusplus"
console.log("e^{π} = " + exp(pi))

export {};
import a,{aaa as bbb} from 'ccc';
import('runtime_import');