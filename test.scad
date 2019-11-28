use <rack_cover.scad>;
include <constants.scad>;

module create_full_1u_panel(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  panel_width_internal = panel_width - rack_mount_width - rack_mount_width;

  for (i = [0:num_panels-1]) {
    translate([panel_width*i,0,0])
      union() {
        if (i == 0) {
          difference() {
            create_1u_panel(num_panels);
            translate([panel_width/2,0,1u_height/2+1.5])
              color("green") fangrill(40, 6, 2);
          }
        } else if (i == 1) {
          difference() {
            create_1u_panel(num_panels);
            translate([panel_width/2,0,1u_height/2+1.5])
              color("green") grill(panel_width_internal-20, 35, 10, 3);
          }
        } else {
          create_1u_panel(num_panels);
        }        create_tray(num_panels);
      }
  }
}

module create_full_2u_panel(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
  panel_width_internal = panel_width - rack_mount_width - rack_mount_width;

  for (i = [0:num_panels-1]) {
    translate([panel_width*i,0,0])
      union() {
        if (i == 0) {
          difference() {
            create_2u_panel(num_panels);
            translate([panel_width/2,0,1u_height+1.5])
              color("green") fangrill(80, 8, 3);
          }
        } else if (i == 1) {
          difference() {
            create_2u_panel(num_panels);
            translate([panel_width/2,0,1u_height+1.5])
              color("green") grill(panel_width_internal-20, 70, 10, 3);
          }
        } else {
          create_2u_panel(num_panels);
        }
        create_tray(num_panels);
      }
  }
}

module create_panel_joiners(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);

  for (i = [1:num_panels-1]) {
    translate([(panel_width*i)-(rack_mount_width)+1.5,-10,0])
      panel_joiner_m6();

    translate([(panel_width*i)-(rack_mount_width)+1.5,+10,0])
      panel_joiner_cage_nut();
  }
}

module create_panel_joiners_m4(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);

  for (i = [1:num_panels-1]) {
    translate([(panel_width*i)-(rack_mount_width)+1.5,-10,0])
      panel_joiner_m4();

    translate([(panel_width*i)-(rack_mount_width)+1.5,+10,0])
      panel_joiner_m4_nut();
  }
}
module panel_joiner_test_cage() {
  difference() {
    panel_joiner_cage_nut();
    translate([-5,-3.5,+12.5])
      cube([panel_width+10,10,1u_height]);
  }
}

module panel_joiner_test_m6() {
  difference() {
    panel_joiner_m6();
    translate([-5,-3.5,+12.5])
      cube([panel_width+10,10,1u_height]);
  }
}

module vertical_test() {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);

  difference() {
    union() {
      create_1u_panel(4);
      create_tray(4);
    }
    translate([rack_mount_width+2*panel_thickness,-3.5,-5])
      cube([panel_width,120,1u_height*3]);
    translate([0,10,-5])
      cube([panel_width,120,1u_height*3]);
  }
}

module horizontal_test(num_panels) {
  panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);

  difference() {
    union() {
      create_1u_panel(num_panels);
      create_tray(num_panels);
    }
    translate([-5,-3.5,+12])
      cube([panel_width+10,20,1u_height]);
    translate([-5,3,-5])
      cube([panel_width+10,110,1u_height+10]);
  }
}

translate([0,0,1.5*1u_height]) {
  create_full_2u_panel(4);
  create_panel_joiners_m4(4);
  translate([0,0,1u_height])
    create_panel_joiners_m4(4);
}

create_full_1u_panel(4);
create_panel_joiners_m4(4);

translate([0,0,-1.5*1u_height]) {
  create_full_1u_panel(3);
  create_panel_joiners(3);
}

translate([0,0,-4*1u_height]) {
  create_full_2u_panel(3);
  create_panel_joiners(3);
  translate([0,0,1u_height])
    create_panel_joiners(3);
}

translate([0,0,+4*1u_height])
  vertical_test();

translate([50,0,+4*1u_height])
  panel_joiner_test_m6();

translate([50,0,+4.5*1u_height])
  panel_joiner_test_cage();

translate([100,0,+4*1u_height])
  horizontal_test(4);

translate([100,0,+4.5*1u_height])
  horizontal_test(3);
