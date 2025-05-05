//! Project description in Markdown format before the first include.
$pp1_colour = "yellow";           // Override any global defaults here if required, see NopSCADlib/global_defs.scad.
$fn=180; 		//resolution
include <NopSCADlib/lib.scad>   // Includes all the vitamins and utilities in NopSCADlib but not the printed parts.



//! Assembly instructions in Markdown format in front of each module that makes an assembly.
module main_assembly()
assembly("main") {
    mech_box();
}

module mech_box() {
    small_box();
    
    box_height=90;
    feet_height=3.0;
    box_thickness=1.5;
    margin=0.1;
    // clearance for lid holder shapes
    inner_depth=4;
    lift=feet_height+box_thickness+margin;
    // Inner box
    translate([0,0,lift]) {
        color("blue") {
            small_box(box_height-lift-inner_depth,66,96,70,100,box_thickness,2,false,feet_height);
        }
    }
}

module big_floor() { 
    translate([0,0,0.1]) {
        color("gray") {
            test_floor(-40.5,-55.5,13,7);
        }
    }    
}

module test_all_boxes() {
        for(x=[0:1]) {
        for(y=[0:1]) {
            translate([80*x,110*y,0]) {
                // Outer single box with feet
                small_box();
            }
        }
    }

    translate([140,0,0]) {    
        for(x=[0:1]) {
            for(y=[0:0]) {
                translate([40*x,110*y,0]) {
                    // Half box (tall)
                    half_box_tall();
                }
            }
        }
    }
    
    translate([220,-27.5,0]) {    
        for(x=[0:1]) {
            for(y=[0:1]) {
                translate([40*x,55*y,0]) {
                    // Quarter box
                    quarter_box();
                }
            }
        }
    }
    
    translate([0,220-27.5,0]) {
        for(x=[0:0]) {
            for(y=[0:1]) {
                translate([80*x,55*y,0]) {
                    // Half box (Wide)
                    half_box_wide();
                }
            }
        }
    }   
}

module quarter_box() {
    small_box(90,38,53,40,55,1.5,2);
}

module half_box_wide() {
    small_box(90,76,53,80,55,1.5,2);
}

module half_box_tall() {
    small_box(90,38,106,40,110,1.5,2);
}

module test_floor(start_x, start_y, column_count, row_count) {   
    divot_diameter = 19.5;
    divot_radius = divot_diameter/2;
    x_spacing = 20.5;
    y_spacing = 35.5;
    
    translate([start_x,start_y,0]){
        for(x = [0:column_count-1]) {
            for(y = [0:row_count-1]) {
                translate([(x_spacing+divot_diameter)*x,(y_spacing+divot_diameter)*y,0]) {
                    cylinder(h=0.1,r=divot_radius,center=false);
                }
            }
        }
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

module small_box(height=90,bottom_x=76,bottom_y=106,top_x=80,top_y=110,thickness=1.5,rounding=2,feet=true, feet_height = 3) {
    feet_lift = feet ? feet_height : 0;
    union() {
        translate([0,0,feet_lift]) {
            small_box_box(height,bottom_x,bottom_y,top_x,top_y,thickness,rounding);
        }
        if (feet) {
            foot_size = 7.0;
            foot_join_height = feet_lift + (thickness / 2.0);
            translate_x = (bottom_x / 2.0) - (foot_size / 2.0);
            translate_y = (bottom_y / 2.0) - (foot_size / 2.0);
            
            translate([-1*translate_x,-1*translate_y,0]) {
                rotate(45) {
                    foot(foot_size,foot_join_height,rounding);    
                }
            }
            translate([-1*translate_x,translate_y,0]) {
                rotate(-45) {
                    foot(foot_size,foot_join_height,rounding);    
                }
            }
            
            translate([translate_x,-1*translate_y,0]) {
                rotate(135) {
                    foot(foot_size,foot_join_height,rounding);    
                }
            }
            
            translate([translate_x,translate_y,0]) {
                rotate(-135) {
                    foot(foot_size,foot_join_height,rounding);    
                }
            }
        }
    }
}

module foot(foot_size,foot_height,rounding) {
    difference() {
        rotate(45) {
            rounded_rectangle([foot_size,foot_size,foot_height], r=rounding,center=false);
        }
        foot_cut = foot_size+rounding;
        foot_cut_height = foot_height+rounding;
        translate([0,-1 * (foot_cut / 2.0),-0.5]) {
                cube([foot_cut,foot_cut,foot_cut_height], center=false);
        }
    }
}

// These boxes are measured by outer dimensions
module small_box_box(height,bottom_x,bottom_y,top_x,top_y,thickness,rounding) { 
    difference() {
        solid_box(height,bottom_x,bottom_y,top_x,top_y,rounding);
        translate([0,0,thickness]) {
            gap = thickness * 2;
            solid_box(height,bottom_x-gap,bottom_y-gap,top_x-gap,top_y-gap,rounding);
        }
    }
}

module solid_box(height,bottom_x,bottom_y,top_x,top_y,rounding) {
   hull(){
        translate([0,0,height]) {
            rounded_rectangle(size = [top_x, top_y, 1], r = rounding, center = false, xy_center = true);
        }
        rounded_rectangle(size = [bottom_x, bottom_y, 1], r = rounding, center = false, xy_center = true);
   }
}



main_assembly();