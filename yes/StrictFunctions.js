function strict() {
  'use strict';
  function nested()
  {
    let a = 4; 
    return 'And so am I!';
  }
  return "Hi!  I'm a strict mode function!  " + nested();
}

function notStrict() {
  var let = 0;
  return "I'm not strict.";
}