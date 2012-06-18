set rpt   my_report_timing


set search_path         "."

set search_path [concat $search_path  \
                   [list  \
                         "../include" \
                   ] \
                ]


#set synthetic_library [list standard.sldb dw01.sldb dw02.sldb dw03.sldb dw04.sldb dw06.sldb dw_foundation.sldb]
set synthetic_library [list dw_foundation.sldb]

set link_library [concat $synthetic_library \
                    [list  * \
                           lib/tsmc35/core_33v/synopsys/typical.db \
                     ] \
                   ]


   ##### Use high Vt and normal Vt library
   set target_library  [list lib/tsmc35/core_33v/synopsys/typical.db ]

#set_dont_use [list #########/*_AS_*]


#    set verilogout_show_unconnected_pins true
#    set hdlin_enable_vpp true

    #define some new variables
    set COMPILE_WITH_SCAN ""
    set COMPILE_WITH_INC  ""
    set DW_UNGROUP_BEF_COMP 0

#suppress some warning 
#suppress_message VER-130
#suppress_message VER-936
#suppress_message TIM-163
#suppress_message UID-401
