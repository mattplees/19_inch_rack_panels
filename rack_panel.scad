include <constants.scad>;
use <nuttrap.scad>;

module cylinder_oval(x, y, z, offset) {
  color("blue") hull() {
    translate([x-(offset/2),y,z])
      cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
    translate([x+(offset/2),y,z])
      cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
  }
}

module create_1u_panel(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  
  translate([0, panel_thickness, 0]) {
    rotate([90,0,0]) {
      translate([0, 1u_height, 0]) {
        difference() {
          translate([0, -1u_height, 0])
            cube([panel_width, 1u_height, panel_thickness]);
        
          cylinder_oval(horz_spacing, -top_spacing, 0, 2.5);
          cylinder_oval(horz_spacing, -(top_spacing+hole_spacing), 0, 2.5);
          cylinder_oval(horz_spacing, -(top_spacing+2*hole_spacing), 0, 2.5);
          cylinder_oval(panel_width-horz_spacing,-top_spacing, 0, 2.5);
          cylinder_oval(panel_width-horz_spacing,-(top_spacing+hole_spacing), 0, 2.5);
          cylinder_oval(panel_width-horz_spacing,-(top_spacing+2*hole_spacing), 0, 2.5);

          translate([panel_width-horz_spacing,-(top_spacing+2*hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
        }
      }
    }
  }
}

module create_2u_panel(num_panels) {
  union() {
    create_1u_panel(num_panels);
    translate([0,0,1u_height]) create_1u_panel(num_panels);
  }
}

module triangle(o_len, a_len, depth, center=false) {
    centroid = center ? [-a_len/3, -o_len/3, -depth/2] : [0, 0, 0];
    translate(centroid) linear_extrude(height=depth)
    {
      polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

module create_tray_joiner(nuttrap) {  
 
  difference() {
    union() {
      // Strenghlening support
      translate([rack_mount_width,0,0])
        rotate([180,180,0])
          triangle(rack_mount_width, rack_mount_width, panel_thickness);
   
      // horizontal from tray
      cube([rack_mount_width, rack_mount_width, panel_thickness]);
      // Vertical join
      cube([tray_join_width, rack_mount_width, rack_mount_width+panel_thickness]);
      translate([tray_join_width,panel_thickness,panel_thickness])
        rotate([90,0,0])
          triangle(rack_mount_width, rack_mount_width-tray_join_width+panel_thickness, panel_thickness);
      translate([tray_join_width,rack_mount_width,panel_thickness])
        rotate([90,0,0])
          triangle(rack_mount_width, rack_mount_width-tray_join_width+panel_thickness, panel_thickness);
    }
    
    if (nuttrap == false) {
      translate([0,rack_mount_width/2,panel_thickness+(rack_mount_width/2)])
        rotate([0,90,0]) 
          color("blue") cylinder(h=rack_mount_width*2, d=join_bolt_dia, center=true);
    }
    else {
      translate([tray_join_width-nut_trap_height,rack_mount_width/2,panel_thickness+(rack_mount_width/2)])
        rotate([0,90,0])
          color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);
      translate([0,rack_mount_width/2,panel_thickness+(rack_mount_width/2)])
        rotate([0,90,0])
          color("blue") cylinder(h=rack_mount_width*2, d=join_bolt_dia, center=true);
    }
  }
}

module create_tray(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  panel_width_internal = panel_width - rack_mount_width - rack_mount_width;
  
  union() {
    translate([rack_mount_width,panel_thickness,0]) {
        cube([panel_width_internal, support_tray_depth, panel_thickness]);
        translate([panel_thickness,0,0])
          rotate([0,-90,0])
            triangle(support_tray_depth, 1u_height, panel_thickness);
        translate([panel_width_internal,0,0])
          rotate([0,-90,0])
            triangle(support_tray_depth, 1u_height, panel_thickness);
      }
      translate([0,support_tray_depth-rack_mount_width+panel_thickness,0]) {
        create_tray_joiner(true);
      }
      translate([panel_width,support_tray_depth-rack_mount_width+panel_thickness,0]) {
        mirror([180,0,0]) {
          create_tray_joiner(false);
        }
      }
    }
}

module add_pi3() {
  rotate([-90,-90,0])
    translate([-86,40,-1u_height+5])
      color("green")
        import("Raspberry_Pi_3_Light_Version.STL");
}

module panel_joiner() {
  left_reduce = 2;
  right_reduce = 2;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  
  translate([0, -1u_height, 0])
    cube([joiner_width, 1u_height, panel_thickness]);
}

module panel_joiner_m4_nut() {
  left_reduce = 1.5;
  right_reduce = 1.5;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  
  translate([0,panel_thickness,0])
    mirror([0,1,0])
      translate([0, panel_thickness, 0]) {
        rotate([90,0,0]) {
          translate([0, 1u_height, 0]) {
            difference() {
              union() {
                panel_joiner();            
                translate([horz_spacing-left_reduce,-top_spacing,panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);
                translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);
                translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);

                translate([joiner_width-horz_spacing+right_reduce,-top_spacing,panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);
                translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);
                translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),panel_thickness+(nut_trap_height/2)])
                  color("red") cube([nut_trap_holder,nut_trap_holder,nut_trap_height], center=true);
              }
              
              translate([horz_spacing-left_reduce,-top_spacing,panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([horz_spacing-left_reduce,-top_spacing,panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);

              translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);

              translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);

              translate([joiner_width-horz_spacing+right_reduce,-top_spacing,panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([joiner_width-horz_spacing+right_reduce,-top_spacing,panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);

              translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);

              translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),panel_thickness/2])
                color("DeepSkyBlue") cylinder(h=panel_thickness*2, d=join_bolt_dia, center=true);
              translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),panel_thickness])
                color("purple") nut_trap(nut_trap_size, h=nut_trap_height*2);
            }
          }
        }
      }
}

module panel_joiner_m4() {
  left_reduce = 1.5;
  right_reduce = 1.5;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  tolerance = 0.5;
  
  translate([0, panel_thickness, 0]) {
    rotate([90,0,0]) {
      translate([0, 1u_height, 0]) {
        difference() {
          union() {
            panel_joiner();
            translate([horz_spacing-left_reduce,-top_spacing,0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);
            translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);
            translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);

            translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);
            translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);
            translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
              color("red") cylinder(h=panel_thickness*2, d=rack_bolt_dia-tolerance, center=true);
          }
          
          translate([horz_spacing-left_reduce,-top_spacing,0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);

          translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
            color("DeepSkyBlue") cylinder(h=panel_thickness*10, d=join_bolt_dia, center=true);
        }
      }
    }
  }
}

module panel_joiner_m6() {
  left_reduce = 1.5;
  right_reduce = 1.5;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  
  translate([0, panel_thickness, 0]) {
    rotate([90,0,0]) {
      translate([0, 1u_height, 0]) {
        difference() {
          panel_joiner();

          translate([horz_spacing-left_reduce,-top_spacing,0])
            color("DarkOrange") cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
            color("DarkOrange") cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
            color("DarkOrange") cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);

          translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
            color("DarkOrange") cylinder(h=panel_thickness*10, d=rack_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
            color("DarkOrange") cylinder(h=panel_thickness*10, d=rack_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
            color("DarkOrange") cylinder(h=panel_thickness*10, d=rack_bolt_dia, center=true);
        }
      }
    }
  }
}

module panel_joiner_cage_nut() {
  left_reduce = 1.5;
  right_reduce = 1.5;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  cage_nut_hole = 9.5;
  
  translate([0, panel_thickness, 0]) {
    rotate([90,0,0]) {
      translate([0, 1u_height, 0]) {
        difference() {
          panel_joiner();
          
          translate([horz_spacing-left_reduce,-top_spacing,0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);

          translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
            color("DarkOrange") cube(size = cage_nut_hole, center=true);
        }
      }
    }
  }
}

module fangrill(fansize, gap, cutout) {
  rotate([90,0,0]) {
      intersection() {
        for (i = [0:fansize/gap]) {
          hull() {
            translate([-(fansize/2)+(cutout/2)+(i*gap),-(fansize/2),0]) cylinder(h=panel_thickness*3, d=cutout, center=true);
            translate([-(fansize/2)+(cutout/2)+(i*gap),+(fansize/2),0]) cylinder(h=panel_thickness*3, d=cutout, center=true);
          }
        }
        cylinder(h=panel_thickness*3, d=fansize-2, center=true);
      }

      hole_offset = (fansize==40 ? 32 : 
                      (fansize==50 ? 40 : 
                      (fansize==60 ? 50 : 
                      (fansize==70 ? 60 : 
                      (fansize==80 ? 71.5 : 
                      (fansize==92 ? 82.5 : 
                      (fansize==120 ? 105 : 0)))))));

      if (hole_offset != 0)
      {
        hole_dia = 4.6;
        // screw holes
        translate([-hole_offset/2,-hole_offset/2,0])
          cylinder(h=panel_thickness*3, d=hole_dia, center=true);
        translate([+hole_offset/2,-hole_offset/2,0])
          cylinder(h=panel_thickness*3, d=hole_dia, center=true);
        translate([+hole_offset/2,+hole_offset/2,0])
          cylinder(h=panel_thickness*3, d=hole_dia, center=true);
        translate([-hole_offset/2,+hole_offset/2,0])
          cylinder(h=panel_thickness*3, d=hole_dia, center=true);
      }
  }
}

module grill(width, height, gap, cutout) {
  rotate([90,0,0]) {
    for (i = [0:(width/gap)]) {
      hull() {
        translate([-(width/2)+(cutout/2)+(i*gap),-(height/2)+cutout,0]) 
          cylinder(h=panel_thickness*3, d=cutout, center=true);
        translate([-(width/2)+(cutout/2)+(i*gap),+(height/2)-cutout,0]) 
          cylinder(h=panel_thickness*3, d=cutout, center=true);
      }
    }
  }
}


//grill(90, 35, 6, 3);
//fangrill(80, 7, 3);
//fangrill(40, 4, 2);
//create_1u_panel(4);
//create_2u_panel(4);
//create_tray(4);
translate([-175,0,0]){
  create_1u_panel(3);
  create_tray(3);
}

//create_tray_joiner(true);
//translate([0,-20,0]) create_tray_joiner(false);

//panel_joiner_m4();
//translate([40, 0, 0]) panel_joiner_m4_nut();
//panel_joiner_m6();
//translate([40, 0, 0]) panel_joiner_cage_nut();







