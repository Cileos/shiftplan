// namespace = function(name, scope) {
//   var names = name.split(".");
//   var namespace = window;
// 
//   for(var i = 0; i < names.length; i++) {
//     var name = names[i];
//     if(typeof namespace[name] == "undefined") {
//       namespace[name] = new Object();
//     }
//     namespace = namespace[name];
//   }
//   
//   if(scope) {
// //    namespace.extend(scope)
//   }
// }
// 
// namespace('Plan', function() {
//   var Assignment = function() {
//     console.log('Assignment constructor');
//     console.log('Do I know the Shift constructor? ' + typeof(Shift) != 'undefined' ? 'jup' : 'nope')
//   }
// })
// 
// namespace('Plan', function() {
//   var Shift = function() {
//     console.log('Shift constructor')
//     console.log('Do I know the Assignment constructor? ' + typeof(Assignment) != 'undefined' ? 'jup' : 'nope')
//   }
// })

Shiftplan = { }

function namespace(name, scope) {
  scope.apply(Shiftplan)
}

(function() {
  Foo = { 
    name: 'foo', 
    check: function() { 
      if(typeof(Bar) != 'undefined') {
        console.log('Bar\'s name is: ' + Bar.name);
      } else {
        console.log('I don\'t know Bar');
      }
      var e = new Employee
      e.init()
    } 
  };
}.apply(Shiftplan));

(function() {
  Employee = function() {}
  Employee.prototype = {
    init: function() {
      console.log('initializing Employee instance ... this points to:')
      console.log(this)
    }
  }
  Bar = { 
    name: 'bar', 
    check: function() { 
      if(typeof(Foo) != 'undefined') {
        console.log('Foo\'s name is: ' + Foo.name);
      } else {
        console.log('I don\'t know Foo');
      }
    }
  };
  Foo.check();
  Bar.check();
}.apply(Shiftplan));











