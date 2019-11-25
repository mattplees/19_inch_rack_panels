$fn = 100;

// 
panel_thickness = 1.5;
rack_mount_width = 15.875;
rack_bolt_dia = 6.6;

//
1u_height = 44.4;
nineteen_inches_metric = 482.60;
num_panels = 4;
panel_width = ((nineteen_inches_metric - (num_panels - 1)) / num_panels);
panel_width_internal = panel_width - rack_mount_width - rack_mount_width;
// Spacing from the top of the 1u to the first hole
top_spacing = 6.35;
// Gap between holes within the 1u panel
hole_spacing = 15.875;
// Center point for the hole within the rack mount frame
horz_spacing = rack_mount_width / 2;

