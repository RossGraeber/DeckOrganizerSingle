//! Project description in Markdown format before the first include.
$pp1_colour = "yellow";           // Override any global defaults here if required, see NopSCADlib/global_defs.scad.
$fn=180; 		//resolution
include <NopSCADlib/lib.scad>   // Includes all the vitamins and utilities in NopSCADlib but not the printed parts.



//! Assembly instructions in Markdown format in front of each module that makes an assembly.
module main_assembly()
assembly("main") {
    translate([0,0,0]) {
        small_box(true);
    }
    
    color("green") {
        inner_box();
    }

}

module rack_and_pinion() {
    translate([43,30,83]) {
        rotate([0,-90,0]) {
            color("blue") {
                scale([1.0,1.0,3.0]) {
                    involute_gear_profile(m=2, z=15*2, w=5, pa = 20, clearance = undef);
                }
            }
        }
    }
    
    translate([43,0,4.5]) {
        rotate([0,-90,0]) {
            color("red") {
                scale([1.0,1.0,3.0]) {
                    involute_rack_profile(m=2, z=14, w=5, pa = 20, clearance = undef);
                }
            }
        }
    }
}

module inner_box() { 
    difference() {
        hull(){
            translate([0,0,90]) {
                rounded_rectangle(size = [70, 100, 1], r = 2, center = false, xy_center = true);
            }
            rounded_rectangle(size = [66, 96, 1], r = 2, center = false, xy_center = true);
        }
        translate([0,0,1.5]) {
                hull(){
                translate([0,0,90]) {
                    rounded_rectangle(size = [67, 97, 1], r = 2, center = false, xy_center = true);
                }
                rounded_rectangle(size = [63, 93, 1], r = 2, center = false, xy_center = true);
            }
        }
    }
}

module small_box(feet=true) {
    feet_lift = feet ? 3 : 0;
    union() {
        translate([0,0,feet_lift]) {
            small_box_box();
        }
        if (feet) {
            translate([-34.5,-49.5,0]) {
                rotate(45) {
                    foot();    
                }
            }
            translate([-34.5,49.5,0]) {
                rotate(-45) {
                    foot();    
                }
            }
            
            translate([34.5,-49.5,0]) {
                rotate(135) {
                    foot();    
                }
            }
            
            translate([34.5,49.5,0]) {
                rotate(-135) {
                    foot();    
                }
            }
        }
    }
}

module foot() {
    difference() {
        rotate(45) {
            rounded_rectangle([7,7,4], r=2,center=false);
        }
        translate([0,-4.5,-0.5]) {
                
                cube([9,9,6], center=false);
        }
    }
}

module small_box_box() { 
    difference() {
        hull(){
            translate([0,0,90]) {
                rounded_rectangle(size = [80, 110, 1], r = 2, center = false, xy_center = true);
            }
            rounded_rectangle(size = [76, 106, 1], r = 2, center = false, xy_center = true);
        }
        translate([0,0,1.5]) {
                hull(){
                translate([0,0,90]) {
                    rounded_rectangle(size = [77, 107, 1], r = 2, center = false, xy_center = true);
                }
                rounded_rectangle(size = [73, 103, 1], r = 2, center = false, xy_center = true);
            }
        }
    }
}

main_assembly();