include <constants.scad>;
use <triangles.scad>;

module create_1u_panel(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  
  translate([0, panel_thickness, 0]) {
    rotate([90,0,0]) {
      translate([0, 1u_height, 0]) {
        difference() {
          translate([0, -1u_height, 0])
            cube([panel_width, 1u_height, panel_thickness]);
        
          translate([horz_spacing,-top_spacing,0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing,-(top_spacing+hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing,-(top_spacing+2*hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          
          translate([panel_width-horz_spacing,-top_spacing,0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([panel_width-horz_spacing,-(top_spacing+hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
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

module create_tray(num_panels) {
  support_tray_depth = 100;
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  panel_width_internal = panel_width - rack_mount_width - rack_mount_width;

  translate([rack_mount_width,panel_thickness,0]) {
    union() {
      cube([panel_width_internal, support_tray_depth, panel_thickness]);
      translate([panel_thickness,0,0])
        rotate([0,-90,0])
          triangle(support_tray_depth, 1u_height, panel_thickness);
      translate([panel_width_internal,0,0])
        rotate([0,-90,0])
          triangle(support_tray_depth, 1u_height, panel_thickness);
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
  left_reduce = 1.5;
  right_reduce = 1.5;
  joiner_width = (rack_mount_width * 2) - left_reduce - right_reduce;
  
  translate([0, -1u_height, 0])
    cube([joiner_width, 1u_height, panel_thickness]);
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
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);

          translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
            cylinder(h=panel_thickness*3, d=rack_bolt_dia, center=true);
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
            cube(size = cage_nut_hole, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+hole_spacing),0])
            cube(size = cage_nut_hole, center=true);
          translate([horz_spacing-left_reduce,-(top_spacing+2*hole_spacing),0])
            cube(size = cage_nut_hole, center=true);

          translate([joiner_width-horz_spacing+right_reduce,-top_spacing,0])
            cube(size = cage_nut_hole, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+hole_spacing),0])
            cube(size = cage_nut_hole, center=true);
          translate([joiner_width-horz_spacing+right_reduce,-(top_spacing+2*hole_spacing),0])
            cube(size = cage_nut_hole, center=true);
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
        translate([-(width/2)+(cutout/2)+(i*gap),-(height/2)+cutout,0]) cylinder(h=panel_thickness*3, d=cutout, center=true);
        translate([-(width/2)+(cutout/2)+(i*gap),+(height/2)-cutout,0]) cylinder(h=panel_thickness*3, d=cutout, center=true);
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
//panel_joiner_m6();
//panel_joiner_cage_nut();
