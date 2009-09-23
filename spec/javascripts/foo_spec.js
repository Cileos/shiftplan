require("spec_helper.js");  
// require("../../public/javascripts/app/hide_author_email.js");  
  
Screw.Unit(function(){  
  describe("foo", function(){  
    it("foo element should be foo'ed",function(){  
      expect($('#foo').length).to(equal, 1);    
      expect($('#foo').text()).to(equal, 'FOO');    
    });  
  });  
});