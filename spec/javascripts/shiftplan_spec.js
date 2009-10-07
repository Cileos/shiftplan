require("spec_helper.js");

Screw.Unit(function() {
  describe("Shiftplan:", function() {
    it("should find a navigation element",function() {
      expect($('#navigation').length).to(equal, 1);
      expect($('#navigation li:first a').text()).to(equal, 'Overview');
    });
  });

  describe("Plan:", function() {
    it("should contain a list of shift collections",function() {
      expect($('.plan .shifts .shift')).to_not(be_empty);
    });
  });

  describe("Shift:", function() {
    it("should contain a list of requirements",function() {
      expect($('.plan .shift .requirements .requirement')).to_not(be_empty);
    });

    it("should have two resize handles",function() {
      expect($('.plan .shift:first-child .resize_handle').length).to(equal, 2);
    });
  });

  describe("Sidebar:", function() {
    it("should contain an employees list",function() {
      expect($('#employees li a.employee')).to_not(be_empty);
    });

    it("should have prepended a div to the employees",function() {
      expect($('#employees li a.employee div')).to_not(be_empty);
    });

    it("should contain an workplaces list",function() {
      expect($('#workplaces li a.workplace')).to_not(be_empty);
    });

    it("should have prepended a div to the workplaces",function() {
      expect($('#workplaces li a.workplace div')).to_not(be_empty);
    });

    it("should contain an qualifications list",function() {
      expect($('#qualifications li a.qualification')).to_not(be_empty);
    });

    it("should have prepended a div to the qualifications",function() {
      expect($('#qualifications li a.qualification div')).to_not(be_empty);
    });
  });
});