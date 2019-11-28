//nut trap
//default values are for M3 nut
//if you use this module as a nut trap cutout, you need to add +de (ie 0.1mm or similiar) to height
//in order to get non-manifold cutouts
module nut_trap (
        w = 5.5,
        h = 3
        )
{
        cylinder(r = w / 2 / cos(180 / 6) + 0.05, h=h, $fn=6);
}    

nut_trap();
