extensions [ matrix csv]


breed [markets market]
breed [offices office]
breed [leisures leisure]
breed [schools school]
breed [houses house]
breed [arrows arrow]
;breed [citizens citizen]
breed [GPones GPone]
breed [GPtwos GPtwo]
breed [GPthrees GPthree]
BREED [GPfours GPfour]
breed [spinners sprinner]

undirected-link-breed [routins routin]

globals
[max-cases wellbeing wellbeing-num risk-facility risk-facility-num risk-transport risk-transport-num cost cost-norm speed speed-norm SaptialRisk?
 routin&transport-risk avg-routin&transport-risk routin&transport-risk-matix
 num-C-market num-C-office num-C-school num-C-leisure num-C-house
 num-C-bus num-C-metro num-C-walk num-C-bike num-C-car num-C-taxi
 num-GPone-bus num-GPone-metro num-GPone-walk num-GPone-bike num-GPone-car num-GPone-taxi
 num-GPtwo-bus num-GPtwo-metro num-GPtwo-walk num-GPtwo-bike num-GPtwo-car num-GPtwo-taxi
 num-GPthree-bus num-GPthree-metro num-GPthree-walk num-GPthree-bike num-GPthree-car num-GPthree-taxi
 num-GPone-market num-GPone-office num-GPone-school num-GPone-leisure num-GPone-house
 num-GPtwo-market num-GPtwo-office num-GPtwo-school num-GPtwo-leisure num-GPtwo-house
 num-GPthree-market num-GPthree-office num-GPthree-school num-GPthree-leisure num-GPthree-house
 num-GPone-market-list num-GPone-office-list num-GPone-school-list num-GPone-leisure-list num-GPone-house-list
 num-GPtwo-market-list num-GPtwo-office-list num-GPtwo-school-list num-GPtwo-leisure-list num-GPtwo-house-list
 num-GPthree-market-list num-GPthree-office-list num-GPthree-school-list num-GPthree-leisure-list num-GPthree-house-list
 num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
 num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
 num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list
  avr-link-dis
 tick-n]

;; patches R-level are defined by infection cases
patches-own
[ cases-here      ; the current number of cases on this patch
  max-cases-here]  ; the maximum number of cases this patch can hold

;; Each facility has atributes: R-level; satisfaction-level

;markets-own [ R-level W-level]
;offices-own [ R-level W-level]
;schools-own [ R-level W-level]
;leisures-own [ R-level W-level]
;houses-own   [ R-level W-level]

routins-own [SR-level SR-routin Max-SR-routin Min-SR-routin SR-routin-norm SR-routin&transport Dis ]
arrows-own  [SR startpoint point1 point2 mypath step-in-path]

GPones-own
[ myhouse mylocation  next-arrival mytransport
  exposure  exposure-facility  exposure-facility-num exposure-transport exposure-transport-num vulnerability mywellbeing  integrate-mywellbeing
 ; citizen-neighbor
  P-transport-initial P-transport-previous P-transport-temp P-transport-next PSI-transport PSI-transport-total
  Value-transport Value-transport-sum
  P-facility-initial P-facility-previous P-facility-next P-facility-temp P-facility-total PSI-facility PSI-facility-total
  Value-facility Value-facility-sum
  W-f-wellbeing W-f-risk W-t-speed W-t-cost W-t-risk
 ; mypath step-in-path
  ;P-neighbor-next avg-P-neighbor-next
]
GPtwos-own
[ myhouse mylocation  next-arrival mytransport
  exposure  exposure-facility  exposure-facility-num exposure-transport exposure-transport-num  vulnerability mywellbeing  integrate-mywellbeing
  ;citizen-neighbor
  P-transport-initial P-transport-previous P-transport-temp P-transport-next PSI-transport PSI-transport-total
  Value-transport Value-transport-sum Value-transport-previous XValue-transport XValue-transport-average
  P-facility-initial P-facility-previous P-facility-next P-facility-temp P-facility-total PSI-facility PSI-facility-total
  Value-facility Value-facility-sum
   W-f-wellbeing W-f-risk W-t-speed W-t-cost W-t-risk
 ; mypath step-in-path
  ;P-neighbor-next avg-P-neighbor-next
]

GPthrees-own
[ myhouse mylocation  next-arrival mytransport
  exposure exposure-facility  exposure-facility-num exposure-transport exposure-transport-num  vulnerability mywellbeing  integrate-mywellbeing
  citizen-neighbor
  P-transport-initial P-transport-previous P-transport-temp P-transport-next PSI-transport PSI-transport-total
  Value-transport Value-transport-sum
  P-facility-initial P-facility-previous P-facility-next P-facility-temp P-facility-total PSI-facility PSI-facility-total
  Value-facility Value-facility-sum
  mypath step-in-path
  W-f-wellbeing W-f-risk W-t-speed W-t-cost W-t-risk
  ;P-neighbor-next avg-P-neighbor-next
]

to-report facilitys
  let cmp turtles with [breed = markets or breed = offices or breed = leisures or breed = schools] ;or breed = houses
  report cmp
end

to-report stops
  let cmp turtles with [breed = markets or breed = offices or breed = leisures or breed = schools or breed = houses]
  report cmp
end

to-report citizens
  let cmp turtles with [breed = GPones or breed = GPtwos or breed = GPthrees]
  report cmp
end
;;================================================================================================

to setup
  clear-all
  ;; set global variables to appropriate values
  ;; call other procedures to set up various parts of the world
  setup-patches
  setup-facilitys
  setup-links
  setup-citizens
  spread-out-citizens

  set Wellbeing[0.2 0.15 0.2 0.2] set wellbeing-num n-values 4[0];; market school office leisure
  set Risk-facility[0.43 0.40 0.37 0.50] set Risk-facility-num n-values 4 [0]

  set cost n-values 6 [0]  set cost-norm n-values 6 [0] ;;     bus  metro  walk  bike  car  taxi
  set speed [40 60 5 16 45 45] set speed-norm n-values 6 [0]
  set risk-transport [0.43	0.43	0.27	0.23	0.10	0.40] set risk-transport-num n-values 6 [0]

;  setup-spatial-arrow
;  go-spatial-arrow
;  update-transportation-risk
   update-cost
 ; update-speed

  set num-C-house num-GPones + num-GPtwos + num-GPthrees
  set num-C-market 0 set num-C-school 0 set num-C-office 0 set num-C-leisure 0
  set  num-C-bus 0 set num-C-metro 0 set num-C-walk 0 set  num-C-bike 0 set num-C-car 0 set num-C-taxi 0
  set num-GPone-bus 0 set num-GPone-metro 0 set num-GPone-walk 0 set num-GPone-bike 0 set num-GPone-car 0 set num-GPone-taxi 0
  set num-GPtwo-bus 0 set num-GPtwo-metro 0 set num-GPtwo-walk 0 set num-GPtwo-bike 0 set num-GPtwo-car 0 set num-GPtwo-taxi 0
  set num-GPthree-bus 0 set num-GPthree-metro 0 set num-GPthree-walk 0 set num-GPthree-bike 0 set num-GPthree-car 0 set num-GPthree-taxi 0
  set num-GPone-market 0 set num-GPone-school 0 set num-GPone-office 0 set num-GPone-leisure 0
  set num-GPtwo-market 0 set num-GPtwo-school 0 set num-GPtwo-office 0 set num-GPtwo-leisure 0
  set num-GPthree-market 0 set num-GPthree-school 0 set num-GPthree-office 0 set num-GPthree-leisure 0
  set num-GPone-bus-list [] set num-GPone-metro-list [] set num-GPone-walk-list [] set num-GPone-bike-list [] set num-GPone-car-list [] set num-GPone-taxi-list []
  set num-GPtwo-bus-list [] set num-GPtwo-metro-list [] set num-GPtwo-walk-list [] set num-GPtwo-bike-list [] set num-GPtwo-car-list [] set num-GPtwo-taxi-list []
  set num-GPthree-bus-list [] set num-GPthree-metro-list [] set num-GPthree-walk-list [] set num-GPthree-bike-list [] set num-GPthree-car-list [] set num-GPthree-taxi-list []
  set num-GPone-market-list [] set num-GPone-office-list [] set num-GPone-school-list [] set num-GPone-leisure-list [] set num-GPone-house-list []
  set num-GPtwo-market-list [] set num-GPtwo-office-list [] set num-GPtwo-school-list [] set num-GPtwo-leisure-list [] set num-GPtwo-house-list []
  set num-GPthree-market-list [] set num-GPthree-office-list [] set num-GPthree-school-list [] set num-GPthree-leisure-list [] set num-GPthree-house-list []

  ;;creat a colock
  create-spinners 1
  [ set shape "clock"
    setxy (max-pxcor - 4) (max-pycor - 4)
    set color Grey
    set size 6
    set heading 8
    set label 8
    set label-color black ]

  set tick-n 0
  reset-ticks
end


;;==============================================================================================
;; set up the initial number of cases each patch has
to setup-patches
 ; clear-all
  resize-world -30 30 -30 30                                                                                       ; 1- Define the size of the world
  set-patch-size 9
  set max-cases 5
  ;; give some patches the highest number of cases possible --
  ;; these patches have the "higest risk"
  ask patches
    [ set max-cases-here 0
      if (random-float 100.0) <= percent-highest-risk
        [ set max-cases-here max-cases
          set cases-here max-cases-here ] ]
  ;; spread that cases around the window a little and put a little back
  ;; into the patches that are the "risk area" found above
  repeat 5
    [ ask patches with [max-cases-here != 0]
        [ set cases-here max-cases-here ]
      diffuse cases-here 0.2 ]
  repeat 10
    [ diffuse cases-here 0.2 ]          ;
  ask patches
    [ set cases-here floor cases-here    ;
      set max-cases-here cases-here      ;
      recolor-patch ]
end

to recolor-patch  ;; patch procedure -- use color to indicate transmision risk level
  set pcolor scale-color orange cases-here max-cases 0
end

;;======================================================================================================
to setup-facilitys

  create-houses num-houses
  [ set shape "app" set color lime set size 9 setxy random-xcor random-ycor
 ;   set R-level 0  set W-level 0
    ;set label R-level set label-color red
  ;  set myneighbor link-neighbors
  ]

  create-markets 1
  [ set shape "supermarket" set size 10 set color 75 find-location
;    set R-level 0.43  set W-level 0.3
    ;set label R-level set label-color red
   ; set myneighbor link-neighbors
  ]

  create-offices 1
  [ set shape "office" set size 12 set color 105 find-location
 ;   set R-level 0.37 set W-level 0.2
    ;set label R-level set label-color
 ;   set myneighbor link-neighbors
  ]

  create-schools 1
  [ set shape "school" set color 115 set size 9 find-location
;    set R-level 0.5 set W-level 0.1
    ;set label R-level set label-color
 ;   set myneighbor link-neighbors
  ]

  create-leisures 1
  [ set shape "leisure" set color 45 set size 12 find-location
 ;   set R-level 0.5 set W-level 0.2
    ;set label R-level set label-color red
 ;   set myneighbor link-neighbors
  ]
end

;;==================================================================================================
to find-location
  let located? false
  while [not located?]
  [
    setxy random-pxcor random-pycor
   ; fd 45
  ;  rt 90
  let num-neighbours count other facilitys in-radius 20
  set located? (num-neighbours = 0)
  ]
end
;;=============================================================================================================================================
to setup-links
  with-local-randomness [
    ask stops [
    let me who
      ask other stops with [who < me]
      [create-routin-with turtle me]
    ]
  ]

  repeat 10
  [
    layout-spring stops links 0.3 (world-width / (sqrt (count stops))) 1
  ]

  ask routins
  [
    set Dis link-length / 10
   ; create-turtle 1 [setxy [xcor] of [end1] of routins [ycor] of [end1] of routins]
   ; set point2 [end2] of routins
  ]

  ask routins
  [set avr-link-dis mean [Dis] of routins]

end
;;==========================================================================================================================

to setup-spatial-arrow

  set-default-shape arrows "arrow"
  create-arrows 120
  [set color white
   set startpoint one-of offices]
  create-arrows 120
  [set color white
   set startpoint one-of markets]
  create-arrows 120
  [set color white
   set startpoint one-of schools]
  create-arrows 120
  [set color white
   set startpoint one-of leisures]

  if num-houses > 0
  [ let i 0
    while [i < num-houses]
    [ create-arrows 120
      [set color white set startpoint house i]
       set i i + 1
    ]
  ]
   ask arrows
  [
   move-to startpoint
   set SR 0
   set point1 startpoint
   set point2  one-of [link-neighbors] of startpoint
  ]


  if hidden-test-agent? [ask arrows [ set hidden? true]]
end

to go-spatial-arrow
   ask arrows[
   ; set mypath []
  ;  set step-in-path 0
    if (distance point2 >= 1)
     [face point2
    ; set mypath fput self mypath
       fd 1
       set SR SR + cases-here]
   ;  set step-in-path step-in-path + 1
    if (distance point2 < 1) [stop]
  ]


  ask routins[
  ; if (end1 = [point1] of arrows ) and (end2 = [point2] of arrows )
    set SR-level [SR] of arrows with [( point1 = [end1] of myself) and (point2 = [end2] of myself ) ]
    set SR-routin (mean SR-level)
  ]

   if hidden-test-agent? [ask arrows [ set hidden? true]]
end

to update-spatialtransportation-risk

    ask routins [
    set MAX-SR-routin  max [SR-routin] of routins
    SET MIN-SR-routin  min [SR-routin] of routins
    if MIN-SR-routin = 0  [ if [SR-routin] of routins != 0 [set SR-routin-norm SR-routin / MAX-SR-routin]
                            if [SR-routin] of routins = 0 [set SR-routin-norm 0]]
    if MIN-SR-routin != 0 [ set SR-routin-norm (SR-routin - MIN-SR-routin) / (MAX-SR-routin - MIN-SR-routin)]

    set SR-routin-norm precision SR-routin-norm 4
    set label SR-routin-norm  set label-color black

    set SR-routin&transport n-values 6 [0]
    set SR-routin&transport replace-item 0 SR-routin&transport (item 0 risk-transport + 0.01 * SR-routin-norm)
    set SR-routin&transport replace-item 1 SR-routin&transport (item 1 risk-transport + 0.01 * SR-routin-norm)
    set SR-routin&transport replace-item 2 SR-routin&transport (item 2 risk-transport + SR-routin-norm * 0.1)
    set SR-routin&transport replace-item 3 SR-routin&transport (item 3 risk-transport + SR-routin-norm * 0.1)
    set SR-routin&transport replace-item 4 SR-routin&transport (item 4 risk-transport + SR-routin-norm * 0.01)
    set SR-routin&transport replace-item 5 SR-routin&transport (item 5 risk-transport + 0.01 * SR-routin-norm)
    ]

    ask routins[
    let j count routins
    set routin&transport-risk n-values  j [0]
    set avg-routin&transport-risk n-values 6 [0]

    set routin&transport-risk [SR-routin&transport] of routins
    set routin&transport-risk-matix matrix:from-row-list routin&transport-risk
    let i 0
    repeat 6 [
    set avg-routin&transport-risk replace-item i avg-routin&transport-risk (mean matrix:get-column routin&transport-risk-matix i)
    set avg-routin&transport-risk replace-item i avg-routin&transport-risk (precision item i avg-routin&transport-risk  4)
    set i i + 1
    ]]


    if SR? = true
   [
    set  Risk-transport replace-item 0 Risk-transport (item 0  avg-routin&transport-risk)
    set  Risk-transport replace-item 1 Risk-transport (item 1  avg-routin&transport-risk)
    set  Risk-transport replace-item 2 Risk-transport (item 2  avg-routin&transport-risk)
    set  Risk-transport replace-item 3 Risk-transport (item 3  avg-routin&transport-risk)
    set  Risk-transport replace-item 4 Risk-transport (item 4  avg-routin&transport-risk)
    set  Risk-transport replace-item 5 Risk-transport (item 5  avg-routin&transport-risk)
       ]
   ; output-print word "Initial risk of transportation pattern:\n" risk-transport
    output-print word "Updated average risk of routin&transportation: \n"  Risk-transport
end

to out-print-destination-value
   output-print word "Initial wellbeing value of destination:\n" Wellbeing
   output-print word "Initial risk of destination:\n" risk-facility
   output-print      "Finished loading values of facilities!"
end

;;==========================================================================================================================
to update-cost
  set cost replace-item 0 cost (0.44)
  set cost replace-item 1 cost (0.77)
  set cost replace-item 2 cost (0.01)
  set cost replace-item 3 cost (0.01)
  set cost replace-item 4 cost (0.072 * avr-link-dis)
  set cost replace-item 5 cost (1.08 + 0.59 * avr-link-dis)
end

to out-print-transportation-pattern-value
    output-print word "Initial cost value of transportation patterns: \n"  cost
    output-print word "Initial speed value of transportation patterns: \n" speed
    output-print      "Finished loading values of trnsportation patterns!"
    output-print " \n"
end
;;==================================================================================================
to setup-citizens
  create-GPones num-GPones
  [
    set color white
    set shape "face neutral"
    set size 1
    set myhouse one-of houses
    move-to myhouse
    set mylocation myhouse

  ;  set next-arrival nobody

    set exposure 0.01 set exposure-facility n-values 4 [0] set exposure-facility-num n-values 4 [0] set exposure-transport n-values 6 [0] set exposure-transport-num n-values 6 [0]
    set vulnerability 0.5
    ;set label exposure
    set mywellbeing ((3 + random round 2) / 10)
    set integrate-mywellbeing ((random round mywellbeing + 1) / 10)

;    set  W-f-wellbeing F-wellbeing-GPone  set W-f-risk F-risk-GPone set W-t-speed T-speed-GPone  set W-t-cost T-cost-GPone set W-t-risk T-risk-GPone
    set  W-f-wellbeing F-wellbeing-GPone / (F-wellbeing-GPone + F-risk-GPone)
    set  W-f-risk      F-risk-GPone      / (F-wellbeing-GPone + F-risk-GPone)
    set  W-t-speed     T-speed-GPone     / (T-speed-GPone +  T-cost-GPone +  T-risk-GPone)
    set  W-t-cost      T-cost-GPone      / (T-speed-GPone +  T-cost-GPone +  T-risk-GPone)
    set  W-t-risk      T-risk-GPone      / (T-speed-GPone +  T-cost-GPone +  T-risk-GPone)

    ;;=================================================================================facility P=========================================================
    set P-facility-initial  n-values 4 [0]
    set P-facility-previous n-values 4 [0]
    set P-facility-temp     n-values 4 [0]
    set P-facility-next     n-values 4 [0]

    ;;                                                   market school office leisure
    set P-facility-initial replace-item 0 P-facility-initial ((25 + random round 10) / 100)
    set P-facility-initial replace-item 1 P-facility-initial ((0 + random round 0)   / 100)
    set P-facility-initial replace-item 2 P-facility-initial ((30 + random round 5) / 100)
    set P-facility-initial replace-item 3 P-facility-initial ((25 + random round 5) / 100)

    set P-facility-next replace-item 0 P-facility-next (item 0 P-facility-initial / sum P-facility-initial)
    set P-facility-next replace-item 1 P-facility-next (item 1 P-facility-initial / sum P-facility-initial)
    set P-facility-next replace-item 2 P-facility-next (item 2 P-facility-initial / sum P-facility-initial)
    set P-facility-next replace-item 3 P-facility-next (item 3 P-facility-initial / sum P-facility-initial)

    set PSI-facility  n-values 4 [0]
    set PSI-facility-total 0
    set Value-facility n-values 4 [0]


    ;;===============================================================================transportation P=========================================================
    set P-transport-initial  n-values 6 [0]
    set P-transport-previous n-values 6 [0]
    set P-transport-temp     n-values 6 [0]
    set P-transport-next     n-values 6 [0]

    ;;                                                        bus  metro  walk  bike  car  taxi
    set P-transport-initial replace-item 0 P-transport-initial ((15 + random round 5)  / 100)
    set P-transport-initial replace-item 1 P-transport-initial ((25 + random round 10)  / 100)
    set P-transport-initial replace-item 2 P-transport-initial ((10 + random round 5)  / 100)
    set P-transport-initial replace-item 3 P-transport-initial ((15 + random round 5)  / 100)
    set P-transport-initial replace-item 4 P-transport-initial ((0 + random round 0)   / 100)
    set P-transport-initial replace-item 5 P-transport-initial ((5 + random round 5)   / 100)

    set P-transport-next replace-item 0 P-transport-next (item 0 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 1 P-transport-next (item 1 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 2 P-transport-next (item 2 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 3 P-transport-next (item 3 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 4 P-transport-next (item 4 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 5 P-transport-next (item 5 P-transport-initial / sum P-transport-initial)

    set PSI-transport  n-values 6 [0]
    set PSI-transport-total 0
    set Value-transport n-values 6 [0]

  ]

   create-GPtwos num-GPtwos
  [
    set color white
    set shape "face happy"
    set size 1
    set myhouse one-of houses
    move-to myhouse
    set mylocation myhouse

  ;  set next-arrival nobody

    set exposure 0.01 set exposure-facility n-values 4 [0] set exposure-transport n-values 6 [0] set exposure-facility-num n-values 4 [0] set exposure-transport-num n-values 6 [0]
    set vulnerability 0.7
    ;set label exposure
    set mywellbeing ((5 + random round 2) / 10)
    set integrate-mywellbeing ((random round mywellbeing + 3) / 10)

  ;  set  W-f-wellbeing F-wellbeing-GPtwo  set W-f-risk F-risk-GPtwo set W-t-speed T-speed-GPtwo  set W-t-cost T-cost-GPtwo set W-t-risk T-risk-GPtwo
    set  W-f-wellbeing F-wellbeing-GPtwo / (F-wellbeing-GPtwo + F-risk-GPtwo)
    set  W-f-risk      F-risk-GPtwo      / (F-wellbeing-GPtwo + F-risk-GPtwo)
    set  W-t-speed     T-speed-GPtwo     / (T-speed-GPtwo +  T-cost-GPtwo +  T-risk-GPtwo)
    set  W-t-cost      T-cost-GPtwo      / (T-speed-GPtwo +  T-cost-GPtwo +  T-risk-GPtwo)
    set  W-t-risk      T-risk-GPtwo      / (T-speed-GPtwo +  T-cost-GPtwo +  T-risk-GPtwo)

    set P-facility-initial n-values 4 [0]
    set P-facility-previous n-values 4 [0]
    set P-facility-temp n-values 4 [0]
    set P-facility-next n-values 4 [0]

    ;;                                                         market school office leisure
    set P-facility-initial replace-item 0 P-facility-initial ((20 + random round 5) / 100)
    set P-facility-initial replace-item 1 P-facility-initial ((20 + random round 5) / 100)
    set P-facility-initial replace-item 2 P-facility-initial ((20 + random round 5) / 100)
    set P-facility-initial replace-item 3 P-facility-initial ((20 + random round 5) / 100)

    set P-facility-next replace-item 0 P-facility-next (item 0 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 1 P-facility-next (item 1 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 2 P-facility-next (item 2 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 3 P-facility-next (item 3 P-facility-initial / (sum P-facility-initial))

    set PSI-facility  n-values 4 [0]
    set PSI-facility-total 0
    set Value-facility n-values 4 [0]

   ;;===============================================================================transportation P=========================================================
    set P-transport-initial  n-values 6 [0]
    set P-transport-previous n-values 6 [0]
    set P-transport-temp     n-values 6 [0]
    set P-transport-next     n-values 6 [0]

    ;;                                                        bus  metro  walk  bike  car  taxi
    set P-transport-initial replace-item 0 P-transport-initial ((15 + random round 5) / 100)
    set P-transport-initial replace-item 1 P-transport-initial ((15 + random round 5) / 100)
    set P-transport-initial replace-item 2 P-transport-initial ((5 + random round 5)  / 100)
    set P-transport-initial replace-item 3 P-transport-initial ((10 + random round 5)  / 100)
    set P-transport-initial replace-item 4 P-transport-initial ((20 + random round 5)  / 100)
    set P-transport-initial replace-item 5 P-transport-initial ((5 + random round 5)  / 100)

    set P-transport-next replace-item 0 P-transport-next (item 0 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 1 P-transport-next (item 1 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 2 P-transport-next (item 2 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 3 P-transport-next (item 3 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 4 P-transport-next (item 4 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 5 P-transport-next (item 5 P-transport-initial / sum P-transport-initial)

    set PSI-transport  n-values 6 [0]
    set PSI-transport-total 0
    set Value-transport n-values 6 [0]


  ]

   create-GPthrees num-GPthrees
  [
    set color white
    set shape "face sad"
    set size 1
    set myhouse one-of houses
    move-to myhouse
    set mylocation myhouse

  ;  set next-arrival nobody

    set exposure 0.01 set exposure-facility n-values 4 [0] set exposure-transport n-values 6 [0] set exposure-facility-num n-values 4 [0] set exposure-transport-num n-values 6 [0]
    set vulnerability 0.3
    ;set label exposure
    set mywellbeing ((7 + random round 2) / 10)
    set integrate-mywellbeing ((random round mywellbeing + 5) / 10)

 ;   set  W-f-wellbeing F-wellbeing-GPthree set W-f-risk F-risk-GPthree set W-t-speed T-speed-GPthree set W-t-cost T-cost-GPthree set W-t-risk T-risk-GPthree
    set  W-f-wellbeing (F-wellbeing-GPthree / (F-wellbeing-GPthree + F-risk-GPthree))
    set  W-f-risk      (F-risk-GPthree      / (F-wellbeing-GPthree + F-risk-GPthree))
    set  W-t-speed     (T-speed-GPthree    / (T-speed-GPthree +  T-cost-GPthree +  T-risk-GPthree))
    set  W-t-cost      (T-cost-GPthree     / (T-speed-GPthree +  T-cost-GPthree +  T-risk-GPthree))
    set  W-t-risk      (T-risk-GPthree     / (T-speed-GPthree +  T-cost-GPthree +  T-risk-GPthree))

    set P-facility-initial n-values 4 [0]
    set P-facility-previous n-values 4 [0]
    set P-facility-temp n-values 4 [0]
    set P-facility-next n-values 4 [0]

    ;;                                                         market school office leisure
    set P-facility-initial replace-item 0 P-facility-initial ((15 + random round 5) / 100)
    set P-facility-initial replace-item 1 P-facility-initial ((0 + random round 0) / 100)
    set P-facility-initial replace-item 2 P-facility-initial ((35 + random round 5) / 100)
    set P-facility-initial replace-item 3 P-facility-initial ((35 + random round 5) / 100)

    set P-facility-next replace-item 0 P-facility-next (item 0 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 1 P-facility-next (item 1 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 2 P-facility-next (item 2 P-facility-initial / (sum P-facility-initial))
    set P-facility-next replace-item 3 P-facility-next (item 3 P-facility-initial / (sum P-facility-initial))

    set PSI-facility  n-values 4 [0]
    set PSI-facility-total 0
    set Value-facility n-values 4 [0]


   ;;===============================================================================transportation P=========================================================
    set P-transport-initial  n-values 6 [0]
    set P-transport-previous n-values 6 [0]
    set P-transport-temp     n-values 6 [0]
    set P-transport-next     n-values 6 [0]

    ;;                                                        bus  metro  walk  bike  car  taxi
    set P-transport-initial replace-item 0 P-transport-initial ((5 + random round 5) / 100)
    set P-transport-initial replace-item 1 P-transport-initial ((5 + random round 5) / 100)
    set P-transport-initial replace-item 2 P-transport-initial ((5 + random round 5)  / 100)
    set P-transport-initial replace-item 3 P-transport-initial ((5 + random round 5)  / 100)
    set P-transport-initial replace-item 4 P-transport-initial ((35 + random round 5)  / 100)
    set P-transport-initial replace-item 5 P-transport-initial ((15 + random round 5)  / 100)

    set P-transport-next replace-item 0 P-transport-next (item 0 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 1 P-transport-next (item 1 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 2 P-transport-next (item 2 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 3 P-transport-next (item 3 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 4 P-transport-next (item 4 P-transport-initial / sum P-transport-initial)
    set P-transport-next replace-item 5 P-transport-next (item 5 P-transport-initial / sum P-transport-initial)

    set PSI-transport  n-values 6 [0]
    set PSI-transport-total 0
    set Value-transport n-values 6 [0]

  ]
end

;;==========================================================================================================================
to spread-out-citizens
   ask citizens
  [  if citizens =  GPones  [set heading 180 ]  ;; face south
     if citizens =  GPtwos  [set heading 0 ]  ;; face south

    while [any? other turtles-here] [fd 1]
  ]
end

to count-citizens-in-facilitys
  ask citizens
  [
    if mylocation = one-of markets [set num-C-market num-C-market + 1]
    if mylocation = one-of schools [set num-C-school num-C-school + 1]
    if mylocation = one-of offices [set num-C-office num-C-office + 1]
    if mylocation = one-of leisures[set num-C-leisure num-C-leisure + 1]
   ]
   set num-C-house  num-GPones + num-GPtwos + num-GPthrees - num-C-market - num-C-school - num-C-office - num-C-leisure

  ask GPones
  [ if mylocation = one-of markets [set num-GPone-market num-GPone-market + 1]
    if mylocation = one-of schools [set num-GPone-school num-GPone-school + 1]
    if mylocation = one-of offices [set num-GPone-office num-GPone-office + 1]
    if mylocation = one-of leisures[set num-GPone-leisure num-GPone-leisure + 1]]
  set num-GPone-house num-GPones - num-GPone-market - num-GPone-school - num-GPone-office - num-GPone-leisure

  ask GPtwos
  [ if mylocation = one-of markets [set num-GPtwo-market num-GPtwo-market + 1]
    if mylocation = one-of schools [set num-GPtwo-school num-GPtwo-school + 1]
    if mylocation = one-of offices [set num-GPtwo-office num-GPtwo-office + 1]
    if mylocation = one-of leisures[set num-GPtwo-leisure num-GPtwo-leisure + 1]]
  set num-GPtwo-house num-GPtwos - num-GPtwo-market - num-GPtwo-school - num-GPtwo-office - num-GPtwo-leisure

  ask GPthrees
  [ if mylocation = one-of markets [set num-GPthree-market num-GPthree-market + 1]
    if mylocation = one-of schools [set num-GPthree-school num-GPthree-school + 1]
    if mylocation = one-of offices [set num-GPthree-office num-GPthree-office + 1]
    if mylocation = one-of leisures[set num-GPthree-leisure num-GPthree-leisure + 1]]
  set num-GPthree-house num-GPthrees - num-GPthree-market - num-GPthree-school - num-GPthree-office - num-GPthree-leisure

end
;;==========================================================================================================================

;;=============================================================================================================================
to go
  one-day
  if ticks > 80 [stop]
end

to one-day

  set tick-n 0
  ask spinners [set label 8]
  repeat 7 [ one-step ]
  repeat 1 [tick
            ask spinners [ set heading ticks * 72 set label 24]
            export-citizen-location
            export-citizen-transportation]
 ; ask citizens [ set tmp-exposure exposure]
  ask GPones [set integrate-mywellbeing integrate-mywellbeing - 0.5    set exposure 0.01]
  ask GPtwos [set integrate-mywellbeing integrate-mywellbeing - 0.3    set exposure 0.01]
  ask GPthrees [set integrate-mywellbeing integrate-mywellbeing - 0.1  set exposure 0.01]
  set Risk-facility [0.43 0.40 0.37 0.50]
  set Risk-transport avg-routin&transport-risk

end

to one-step
    normalization
    ask citizens  [do-before-moving]
    ask citizens  [move-to-next-arrival]
    ask citizens  [do-after-moving]
    update-facility-risk
    update-transportation-risk
    ask citizens  [update-P-facility]
    ask citizens  [update-P-transport]
    update-facility-risk
    update-transportation-risk

    recount-citizens-in-facilitys
    spread-out-citizens
    export-citizen-location
    export-citizen-transportation

    tick
    set tick-n tick-n + 1
    ask spinners [set heading ticks * 72 set label tick-n * 2 + 8]
end

;to one-day
;  set mypath [] set step-in-path 0
;  one-step
;  set last-stop myhouse

;end
to normalization
    set wellbeing-num replace-item 0 wellbeing-num ((ITEM 0 wellbeing - MIN WELLBEING  * 0.9) / (MAX wellbeing - MIN wellbeing  * 0.9))
    set wellbeing-num replace-item 1 wellbeing-num ((ITEM 1 wellbeing - MIN WELLBEING  * 0.9) / (MAX wellbeing - MIN wellbeing  * 0.9))
    set wellbeing-num replace-item 2 wellbeing-num ((ITEM 2 wellbeing - MIN WELLBEING  * 0.9) / (MAX wellbeing - MIN wellbeing  * 0.9))
    set wellbeing-num replace-item 3 wellbeing-num ((ITEM 3 wellbeing - MIN WELLBEING  * 0.9) / (MAX wellbeing - MIN wellbeing  * 0.9))

    set risk-facility-num replace-item 0 risk-facility-num ((max risk-facility * 1.1 - item 0 risk-facility) / (max risk-facility * 1.1 - min risk-facility))
    set risk-facility-num replace-item 1 risk-facility-num ((max risk-facility * 1.1 - item 1 risk-facility) / (max risk-facility * 1.1 - min risk-facility))
    set risk-facility-num replace-item 2 risk-facility-num ((max risk-facility * 1.1 - item 2 risk-facility) / (max risk-facility * 1.1 - min risk-facility))
    set risk-facility-num replace-item 3 risk-facility-num ((max risk-facility * 1.1 - item 3 risk-facility) / (max risk-facility * 1.1 - min risk-facility))

   set cost-norm replace-item 0 cost-norm ((max cost * 1.1 - item 0 cost) / (max cost * 1.1 - min cost))
   set cost-norm replace-item 1 cost-norm ((max cost * 1.1 - item 1 cost) / (max cost * 1.1 - min cost))
   set cost-norm replace-item 2 cost-norm ((max cost * 1.1 - item 2 cost) / (max cost * 1.1 - min cost))
   set cost-norm replace-item 3 cost-norm ((max cost * 1.1 - item 3 cost) / (max cost * 1.1 - min cost))
   set cost-norm replace-item 4 cost-norm ((max cost * 1.1 - item 4 cost) / (max cost * 1.1 - min cost))
   set cost-norm replace-item 5 cost-norm ((max cost * 1.1 - item 5 cost) / (max cost * 1.1 - min cost))

   set cost-norm replace-item 0 cost-norm (precision item 0 cost-norm  4)
   set cost-norm replace-item 1 cost-norm (precision item 1 cost-norm  4)
   set cost-norm replace-item 2 cost-norm (precision item 2 cost-norm  4)
   set cost-norm replace-item 3 cost-norm (precision item 3 cost-norm  4)
   set cost-norm replace-item 4 cost-norm (precision item 4 cost-norm  4)
   set cost-norm replace-item 5 cost-norm (precision item 5 cost-norm  4)

   set speed-norm  replace-item 0 speed-norm  ((item 0 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))
   set speed-norm  replace-item 1 speed-norm  ((item 1 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))
   set speed-norm  replace-item 2 speed-norm  ((item 2 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))
   set speed-norm  replace-item 3 speed-norm  ((item 3 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))
   set speed-norm  replace-item 4 speed-norm  ((item 4 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))
   set speed-norm  replace-item 5 speed-norm  ((item 5 speed - min speed   * 0.9) / (max speed - min speed  * 0.9))

   set speed-norm  replace-item 0 speed-norm  (precision item 0 speed-norm  4)
   set speed-norm  replace-item 1 speed-norm  (precision item 1 speed-norm  4)
   set speed-norm  replace-item 2 speed-norm  (precision item 2 speed-norm  4)
   set speed-norm  replace-item 3 speed-norm  (precision item 3 speed-norm  4)
   set speed-norm  replace-item 4 speed-norm  (precision item 4 speed-norm  4)
   set speed-norm  replace-item 5 speed-norm  (precision item 5 speed-norm  4)

    set  Risk-transport-num replace-item 0 Risk-transport-num ((max Risk-transport * 1.1 - item 0 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))
    set  Risk-transport-num replace-item 1 Risk-transport-num ((max Risk-transport * 1.1 - item 1 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))
    set  Risk-transport-num replace-item 2 Risk-transport-num ((max Risk-transport * 1.1 - item 2 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))
    set  Risk-transport-num replace-item 3 Risk-transport-num ((max Risk-transport * 1.1 - item 3 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))
    set  Risk-transport-num replace-item 4 Risk-transport-num ((max Risk-transport * 1.1 - item 4 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))
    set  Risk-transport-num replace-item 5 Risk-transport-num ((max Risk-transport * 1.1 - item 5 Risk-transport ) / (max Risk-transport * 1.1 - min Risk-transport))


end

to do-before-moving
  ask citizens
  [
    if integrate-mywellbeing >= mywellbeing or exposure >= 1 and mylocation != myhouse [set next-arrival myhouse ] ;
    if integrate-mywellbeing >= mywellbeing or exposure >= 1  and mylocation = myhouse  [set next-arrival nobody stop]
    if integrate-mywellbeing < mywellbeing  and exposure < 1 [ find-next-arrival ];
  ]
  ;pen-down

end

to find-next-arrival

  ;;========================================max P as next arrival=======================================
  ask citizens [
 ;   ifelse item 0 P-facility-next = item 1 P-facility-next = item 2 P-facility-next = item 3 P-facility-next
 ;   [set next-arrival min-one-of facilitys [distance myself]]

 ;   [
  ;  let P-facility-next-max max P-facility-next
    if  max P-facility-next = item 0 P-facility-next [set next-arrival one-of markets]
    if  max P-facility-next = item 1 P-facility-next [set next-arrival one-of schools]
    if  max P-facility-next = item 2 P-facility-next [set next-arrival one-of offices]
    if  max P-facility-next = item 3 P-facility-next [set next-arrival one-of leisures]
   ; set moving? true
  ;  ]
  ]
end

to move-to-next-arrival

  if next-arrival != nobody
  [  select-path
     ;pen-down
     move-to next-arrival
     set mylocation next-arrival
;  set next-arrival nobody
  ]
end

to select-path
    ;;                    bus  metro  walk  bike  car  taxi
   ask citizens [
    if  max P-transport-next = item 0 P-transport-next [set color green set mytransport 0]
    if  max P-transport-next = item 1 P-transport-next [set color blue  set mytransport 1]
    if  max P-transport-next = item 2 P-transport-next [set color lime  set mytransport 2]
    if  max P-transport-next = item 3 P-transport-next [set color violet set mytransport 3]
    if  max P-transport-next = item 4 P-transport-next [set color orange set mytransport 4]
    if  max P-transport-next = item 5 P-transport-next [set color yellow set mytransport 5]
    ]

   end

to do-after-moving

    set exposure-facility replace-item 0 exposure-facility (vulnerability * item 0 risk-facility)
    set exposure-facility replace-item 1 exposure-facility (vulnerability * item 1 risk-facility)
    set exposure-facility replace-item 2 exposure-facility (vulnerability * item 2 risk-facility)
    set exposure-facility replace-item 3 exposure-facility (vulnerability * item 3 risk-facility)

    set exposure-facility-num replace-item 0 exposure-facility-num ((max exposure-facility * 1.1 - item 0 exposure-facility) / (max exposure-facility  * 1.1 - min exposure-facility))
    set exposure-facility-num replace-item 1 exposure-facility-num ((max exposure-facility * 1.1 - item 1 exposure-facility) / (max exposure-facility  * 1.1 - min exposure-facility))
    set exposure-facility-num replace-item 2 exposure-facility-num ((max exposure-facility * 1.1 - item 2 exposure-facility) / (max exposure-facility  * 1.1 - min exposure-facility))
    set exposure-facility-num replace-item 3 exposure-facility-num ((max exposure-facility * 1.1 - item 3 exposure-facility) / (max exposure-facility  * 1.1 - min exposure-facility))

    set exposure-transport replace-item 0 exposure-transport (vulnerability * item 0 risk-transport)
    set exposure-transport replace-item 1 exposure-transport (vulnerability * item 1 risk-transport)
    set exposure-transport replace-item 2 exposure-transport (vulnerability * item 2 risk-transport)
    set exposure-transport replace-item 3 exposure-transport (vulnerability * item 3 risk-transport)
    set exposure-transport replace-item 4 exposure-transport (vulnerability * item 4 risk-transport)
    set exposure-transport replace-item 5 exposure-transport (vulnerability * item 5 risk-transport)

    set exposure-transport-num replace-item 0 exposure-transport-num ((MAX exposure-transport * 1.1 - item 0 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))
    set exposure-transport-num replace-item 1 exposure-transport-num ((MAX exposure-transport * 1.1 - item 1 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))
    set exposure-transport-num replace-item 2 exposure-transport-num ((MAX exposure-transport * 1.1 - item 2 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))
    set exposure-transport-num replace-item 3 exposure-transport-num ((MAX exposure-transport * 1.1 - item 3 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))
    set exposure-transport-num replace-item 4 exposure-transport-num ((MAX exposure-transport * 1.1 - item 4 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))
    set exposure-transport-num replace-item 5 exposure-transport-num ((MAX exposure-transport * 1.1 - item 5 exposure-transport) / (MAX exposure-transport * 1.1 - MIN exposure-transport))

     if mylocation = one-of markets
    [ set integrate-mywellbeing (integrate-mywellbeing + item 0 wellbeing * 0.5)
      if mytransport = 0 [ set exposure exposure +  item 0 exposure-facility +   item 0 exposure-transport]
      if mytransport = 1 [ set exposure exposure +  item 0 exposure-facility +   item 1 exposure-transport]
      if mytransport = 2 [ set exposure exposure +  item 0 exposure-facility +   item 2 exposure-transport]
      if mytransport = 3 [ set exposure exposure +  item 0 exposure-facility +   item 3 exposure-transport]
      if mytransport = 4 [ set exposure exposure +  item 0 exposure-facility +   item 4 exposure-transport]
      if mytransport = 5 [ set exposure exposure +  item 0 exposure-facility +   item 5 exposure-transport] ]

    if mylocation = one-of schools
    [set integrate-mywellbeing (integrate-mywellbeing + item 1 wellbeing * 0.5)
      if mytransport = 0 [ set exposure exposure +  item 1 exposure-facility +   item 0 exposure-transport]
      if mytransport = 1 [ set exposure exposure +  item 1 exposure-facility +   item 1 exposure-transport]
      if mytransport = 2 [ set exposure exposure +  item 1 exposure-facility +   item 2 exposure-transport]
      if mytransport = 3 [ set exposure exposure +  item 1 exposure-facility +   item 3 exposure-transport]
      if mytransport = 4 [ set exposure exposure +  item 1 exposure-facility +   item 4 exposure-transport]
      if mytransport = 5 [ set exposure exposure +  item 1 exposure-facility +   item 5 exposure-transport] ]

    if mylocation = one-of offices
    [set integrate-mywellbeing (integrate-mywellbeing + item 2 wellbeing * 0.5)
      if mytransport = 0 [ set exposure exposure +  item 2 exposure-facility +   item 0 exposure-transport]
      if mytransport = 1 [ set exposure exposure +  item 2 exposure-facility +   item 1 exposure-transport]
      if mytransport = 2 [ set exposure exposure +  item 2 exposure-facility +   item 2 exposure-transport]
      if mytransport = 3 [ set exposure exposure +  item 2 exposure-facility +   item 3 exposure-transport]
      if mytransport = 4 [ set exposure exposure +  item 2 exposure-facility +   item 4 exposure-transport]
      if mytransport = 5 [ set exposure exposure +  item 2 exposure-facility +   item 5 exposure-transport] ]

    if mylocation = one-of leisures
    [set integrate-mywellbeing (integrate-mywellbeing + item 3 wellbeing * 0.5)
      if mytransport = 0 [ set exposure exposure +  item 3 exposure-facility +   item 0 exposure-transport]
      if mytransport = 1 [ set exposure exposure +  item 3 exposure-facility +   item 1 exposure-transport]
      if mytransport = 2 [ set exposure exposure +  item 3 exposure-facility +   item 2 exposure-transport]
      if mytransport = 3 [ set exposure exposure +  item 3 exposure-facility +   item 3 exposure-transport]
      if mytransport = 4 [ set exposure exposure +  item 3 exposure-facility +   item 4 exposure-transport]
      if mytransport = 5 [ set exposure exposure +  item 3 exposure-facility +   item 5 exposure-transport] ]

end

to update-P-facility

    set P-facility-previous replace-item 0 P-facility-previous (item 0 P-facility-next)
    set P-facility-previous replace-item 1 P-facility-previous (item 1 P-facility-next)
    set P-facility-previous replace-item 2 P-facility-previous (item 2 P-facility-next)
    set P-facility-previous replace-item 3 P-facility-previous (item 3 P-facility-next)

  ;;========================================setup P-next=================================================

   set Value-facility replace-item 0 Value-facility (item 0 Wellbeing-num * W-f-wellbeing + item 0 exposure-facility-num * W-f-risk )
   set Value-facility replace-item 1 Value-facility (item 1 Wellbeing-num * W-f-wellbeing + item 1 exposure-facility-num * W-f-risk )
   set Value-facility replace-item 2 Value-facility (item 2 Wellbeing-num * W-f-wellbeing + item 2 exposure-facility-num * W-f-risk )
   set Value-facility replace-item 3 Value-facility (item 3 Wellbeing-num * W-f-wellbeing + item 3 exposure-facility-num * W-f-risk  )
   set Value-facility-sum  abs (sum Value-facility)


  set PSI-facility replace-item 0 PSI-facility (item 0 Value-facility * item 0 P-facility-previous)
  set PSI-facility replace-item 1 PSI-facility (item 1 Value-facility * item 1 P-facility-previous)
  set PSI-facility replace-item 2 PSI-facility (item 2 Value-facility * item 2 P-facility-previous)
  set PSI-facility replace-item 3 PSI-facility (item 3 Value-facility * item 3 P-facility-previous)
  set PSI-facility-total sum PSI-facility

  set P-facility-temp replace-item 0 P-facility-temp (item 0 P-facility-previous + alpha * (item 0 P-facility-previous * ((item 0 Value-facility - PSI-facility-total) / Value-facility-sum)))
  set P-facility-temp replace-item 1 P-facility-temp (item 1 P-facility-previous + alpha * (item 1 P-facility-previous * ((item 1 Value-facility - PSI-facility-total) / Value-facility-sum)))
  set P-facility-temp replace-item 2 P-facility-temp (item 2 P-facility-previous + alpha * (item 2 P-facility-previous * ((item 2 Value-facility - PSI-facility-total) / Value-facility-sum)))
  set P-facility-temp replace-item 3 P-facility-temp (item 3 P-facility-previous + alpha * (item 3 P-facility-previous * ((item 3 Value-facility - PSI-facility-total) / Value-facility-sum)))

  set P-facility-next replace-item 0 P-facility-next ((item 0 P-facility-temp ) / (sum P-facility-temp))
  set P-facility-next replace-item 1 P-facility-next ((item 1 P-facility-temp ) / (sum P-facility-temp))
  set P-facility-next replace-item 2 P-facility-next ((item 2 P-facility-temp ) / (sum P-facility-temp))
  set P-facility-next replace-item 3 P-facility-next ((item 3 P-facility-temp ) / (sum P-facility-temp))



  ;;====================================influenced by linked neighbor============================================

;  ask citizens [
;    let n count citizen-neighbor
 ;   set P-neighbor-next n-values  n [0]
;    set avg-P-neighbor-next n-values 4 [0]

;    set P-neighbor-next [P-facility-next] of citizen-neighbor
;    let m matrix:from-row-list P-neighbor-next
;    let i 0
;    repeat 4 [
;    set avg-P-neighbor-next replace-item i avg-P-neighbor-next (mean matrix:get-column m i)
;    set i (i + 1)
;   ]
;  ]

;   ask citizens[
;   set P-facility-next replace-item 0 P-facility-next (item 0 P-facility-next + (item 0 avg-P-neighbor-next * 0.015))
;   set P-facility-next replace-item 1 P-facility-next (item 1 P-facility-next + (item 1 avg-P-neighbor-next * 0.015))
;   set P-facility-next replace-item 2 P-facility-next (item 2 P-facility-next + (item 2 avg-P-neighbor-next * 0.015))
;   set P-facility-next replace-item 3 P-facility-next (item 3 P-facility-next + (item 3 avg-P-neighbor-next * 0.015))
;   ]
end




to update-P-transport

    set P-transport-previous replace-item 0 P-transport-previous (item 0 P-transport-next)
    set P-transport-previous replace-item 1 P-transport-previous (item 1 P-transport-next)
    set P-transport-previous replace-item 2 P-transport-previous (item 2 P-transport-next)
    set P-transport-previous replace-item 3 P-transport-previous (item 3 P-transport-next)
    set P-transport-previous replace-item 4 P-transport-previous (item 4 P-transport-next)
    set P-transport-previous replace-item 5 P-transport-previous (item 5 P-transport-next)
  ;;========================================setup P-next=================================================

   set Value-transport replace-item 0 Value-transport (item 0 speed-norm * W-t-speed + item 0 cost-norm  * W-t-cost + item 0 exposure-transport-num * W-t-risk);
   set Value-transport replace-item 1 Value-transport (item 1 speed-norm * W-t-speed + item 1 cost-norm  * W-t-cost + item 1 exposure-transport-num * W-t-risk);
   set Value-transport replace-item 2 Value-transport (item 2 speed-norm * W-t-speed + item 2 cost-norm  * W-t-cost + item 2 exposure-transport-num * W-t-risk);
   set Value-transport replace-item 3 Value-transport (item 3 speed-norm * W-t-speed + item 3 cost-norm  * W-t-cost + item 3 exposure-transport-num * W-t-risk);
   set Value-transport replace-item 4 Value-transport (item 4 speed-norm * W-t-speed + item 4 cost-norm  * W-t-cost + item 4 exposure-transport-num * W-t-risk);
   set Value-transport replace-item 5 Value-transport (item 5 speed-norm * W-t-speed + item 5 cost-norm  * W-t-cost + item 5 exposure-transport-num * W-t-risk);
   set Value-transport-sum abs (sum Value-transport)


  set PSI-transport replace-item 0 PSI-transport (item 0 Value-transport * item 0 P-transport-previous)
  set PSI-transport replace-item 1 PSI-transport (item 1 Value-transport * item 1 P-transport-previous)
  set PSI-transport replace-item 2 PSI-transport (item 2 Value-transport * item 2 P-transport-previous)
  set PSI-transport replace-item 3 PSI-transport (item 3 Value-transport * item 3 P-transport-previous)
  set PSI-transport replace-item 4 PSI-transport (item 4 Value-transport * item 4 P-transport-previous)
  set PSI-transport replace-item 5 PSI-transport (item 5 Value-transport * item 5 P-transport-previous)
  set PSI-transport-total sum PSI-transport

  set P-transport-temp replace-item 0 P-transport-temp (item 0 P-transport-previous + alpha * (item 0 P-transport-previous * ((item 0 Value-transport - PSI-transport-total) / Value-transport-sum)))
  set P-transport-temp replace-item 1 P-transport-temp (item 1 P-transport-previous + alpha * (item 1 P-transport-previous * ((item 1 Value-transport - PSI-transport-total) / Value-transport-sum)))
  set P-transport-temp replace-item 2 P-transport-temp (item 2 P-transport-previous + alpha * (item 2 P-transport-previous * ((item 2 Value-transport - PSI-transport-total) / Value-transport-sum)))
  set P-transport-temp replace-item 3 P-transport-temp (item 3 P-transport-previous + alpha * (item 3 P-transport-previous * ((item 3 Value-transport - PSI-transport-total) / Value-transport-sum)))
  set P-transport-temp replace-item 4 P-transport-temp (item 4 P-transport-previous + alpha * (item 4 P-transport-previous * ((item 4 Value-transport - PSI-transport-total) / Value-transport-sum)))
  set P-transport-temp replace-item 5 P-transport-temp (item 5 P-transport-previous + alpha * (item 5 P-transport-previous * ((item 5 Value-transport - PSI-transport-total) / Value-transport-sum)))

  set P-transport-next replace-item 0 P-transport-next ((item 0 P-transport-temp) / (sum P-transport-temp))
  set P-transport-next replace-item 1 P-transport-next ((item 1 P-transport-temp) / (sum P-transport-temp))
  set P-transport-next replace-item 2 P-transport-next ((item 2 P-transport-temp) / (sum P-transport-temp))
  set P-transport-next replace-item 3 P-transport-next ((item 3 P-transport-temp) / (sum P-transport-temp))
  set P-transport-next replace-item 4 P-transport-next ((item 4 P-transport-temp) / (sum P-transport-temp))
  set P-transport-next replace-item 5 P-transport-next ((item 5 P-transport-temp) / (sum P-transport-temp))

end



to update-facility-risk

  let m (count citizens with [mylocation = one-of markets] / count citizens)
  let n (count citizens with [mylocation = one-of schools]  / count citizens)
  let l (count citizens with [mylocation = one-of offices ] / count citizens)
  let k (count citizens with [mylocation = one-of leisures] / count citizens)

  set risk-facility replace-item 0 risk-facility (item 0 risk-facility * (1 + 0.1 * m ))
  set risk-facility replace-item 1 risk-facility (item 1 risk-facility * (1 + 0.1 * n ))
  set risk-facility replace-item 2 risk-facility (item 2 risk-facility * (1 + 0.1 * l ))
  set risk-facility replace-item 3 risk-facility (item 3 risk-facility * (1 + 0.1 * k ))

end

to update-transportation-risk

  let a (count citizens with [mytransport = 0] /  count citizens)
  let b (count citizens with [mytransport = 1] /  count citizens)
  let c (count citizens with [mytransport = 2] /  count citizens)
  let d (count citizens with [mytransport = 3] /  count citizens)
  let f (count citizens with [mytransport = 4] /  count citizens)
  let g (count citizens with [mytransport = 5] /  count citizens)

  set risk-transport replace-item 0 risk-transport (item 0 risk-transport  * (1 + 0.3  * a ))
  set risk-transport replace-item 1 risk-transport (item 1 risk-transport  * (1 + 0.3  * b ))
  set risk-transport replace-item 2 risk-transport (item 2 risk-transport  * (1 + 0.2  * c ))
  set risk-transport replace-item 3 risk-transport (item 3 risk-transport  * (1 + 0.1  * d ))
  set risk-transport replace-item 4 risk-transport (item 4 risk-transport  * (1 + 0.0  * f ))
  set risk-transport replace-item 5 risk-transport (item 5 risk-transport  * (1 + 0.1  * g ))


end

to recount-citizens-in-facilitys
  set num-C-market 0 set num-C-office 0 set num-C-school 0 set num-C-leisure 0 set num-C-house 0
  set num-GPone-market 0 set num-GPone-office 0 set num-GPone-school 0 set num-GPone-leisure 0 set num-GPone-house 0
  set num-GPtwo-market 0 set num-GPtwo-office 0 set num-GPtwo-school 0 set num-GPtwo-leisure 0 set num-GPtwo-house 0
  set num-GPthree-market 0 set num-GPthree-office 0 set num-GPthree-school 0 set num-GPthree-leisure 0 set num-GPthree-house 0
  count-citizens-in-facilitys
end

to export-citizen-location
   if ticks mod 1 = 0 [
    set num-GPone-market-list lput num-GPone-market  num-GPone-market-list   set num-GPtwo-market-list lput num-GPtwo-market  num-GPtwo-market-list     set num-GPthree-market-list lput num-GPthree-market  num-GPthree-market-list
    set num-GPone-office-list lput num-GPone-office  num-GPone-office-list   set num-GPtwo-office-list lput num-GPtwo-office  num-GPtwo-office-list     set num-GPthree-office-list lput num-GPthree-office  num-GPthree-office-list
    set num-GPone-school-list lput num-GPone-school  num-GPone-school-list   set num-GPtwo-school-list lput num-GPtwo-school  num-GPtwo-school-list    set num-GPthree-school-list lput num-GPthree-school  num-GPthree-school-list
    set num-GPone-leisure-list lput num-GPone-leisure num-GPone-leisure-list set num-GPtwo-leisure-list lput num-GPtwo-leisure num-GPtwo-leisure-list set num-GPthree-leisure-list lput num-GPthree-leisure num-GPthree-leisure-list
    set num-GPone-house-list  lput  num-GPone-house  num-GPone-house-list    set num-GPtwo-house-list  lput  num-GPtwo-house  num-GPtwo-house-list       set num-GPthree-house-list  lput  num-GPthree-house  num-GPthree-house-list
    ]
end

to  export-citizen-transportation
    set num-C-bus count citizens with [color = green]    set num-GPone-bus   count GPones with [color = green]   set num-GPtwo-bus   count GPtwos with [color = green]   set num-GPthree-bus   count GPthrees with [color = green]
    set num-C-metro count citizens with [color = blue]   set num-GPone-metro count GPones with [color = blue]    set num-GPtwo-metro count GPtwos with [color = blue]    set num-GPthree-metro count GPthrees with [color = blue]
    set num-C-walk count citizens  with [color = lime]   set num-GPone-walk  count GPones with [color = lime]    set num-GPtwo-walk  count GPtwos with [color = lime]    set num-GPthree-walk  count GPthrees with [color = lime]
    set num-C-bike count citizens  with [color = violet] set num-GPone-bike  count GPones with [color = violet]  set num-GPtwo-bike  count GPtwos with [color = violet]  set num-GPthree-bike  count GPthrees with [color = violet]
    set num-C-car  count citizens  with [color = orange] set num-GPone-car   count GPones with [color = orange]  set num-GPtwo-car   count GPtwos with [color = orange]  set num-GPthree-car   count GPthrees with [color = orange]
    set num-C-taxi count citizens  with [color = yellow] set num-GPone-taxi  count GPones with [color = yellow]  set num-GPtwo-taxi  count GPtwos with [color = yellow]  set num-GPthree-taxi  count GPthrees with [color = yellow]

   if ticks mod 1 = 0 [
    set  num-GPone-bus-list    lput num-GPone-bus   num-GPone-bus-list    set  num-GPtwo-bus-list    lput num-GPtwo-bus   num-GPtwo-bus-list   set  num-GPthree-bus-list    lput num-GPthree-bus   num-GPthree-bus-list
    set  num-GPone-metro-list  lput num-GPone-metro num-GPone-metro-list  set  num-GPtwo-metro-list  lput num-GPtwo-metro num-GPtwo-metro-list  set  num-GPthree-metro-list  lput num-GPthree-metro num-GPthree-metro-list
    set  num-GPone-walk-list   lput num-GPone-walk num-GPone-walk-list    set  num-GPtwo-walk-list   lput num-GPtwo-walk num-GPtwo-walk-list     set  num-GPthree-walk-list   lput num-GPthree-walk num-GPthree-walk-list
    set  num-GPone-bike-list   lput num-GPone-bike num-GPone-bike-list    set  num-GPtwo-bike-list   lput num-GPtwo-bike num-GPtwo-bike-list     set  num-GPthree-bike-list   lput num-GPthree-bike num-GPthree-bike-list
    set  num-GPone-car-list    lput num-GPone-car  num-GPone-car-list     set  num-GPtwo-car-list    lput num-GPtwo-car  num-GPtwo-car-list    set  num-GPthree-car-list    lput num-GPthree-car  num-GPthree-car-list
    set  num-GPone-taxi-list   lput num-GPone-taxi num-GPone-taxi-list    set  num-GPtwo-taxi-list   lput num-GPtwo-taxi num-GPtwo-taxi-list   set  num-GPthree-taxi-list   lput num-GPthree-taxi num-GPthree-taxi-list
  ]

end
;;=============================sensitivity analysis===================================================================
to run-scenrios
   setup
   setup-spatial-arrow
   go-spatial-arrow
   update-spatialtransportation-risk
   repeat 10 [one-day]
end
to sensitivity-analysis-scenario
  if scenrios = "non-exposure"
  [ repeat 10
    [run-scenrios
    file-open "GP-Location-nonex.csv"
    file-print csv:to-string (list num-GPone-market-list num-GPone-office-list num-GPone-school-list num-GPone-leisure-list num-GPone-house-list
                                   num-GPtwo-market-list num-GPtwo-office-list num-GPtwo-school-list num-GPtwo-leisure-list num-GPtwo-house-list
                                   num-GPthree-market-list num-GPthree-office-list num-GPthree-school-list num-GPthree-leisure-list num-GPthree-house-list)
    ;file-open "GP-Transportation-nonex.csv"
    ;file-print csv:to-string (list num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
    ;                                num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
    ;                                num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list)
    ]
   file-close-all
  ]
  if scenrios = "low-exposure"
  [ repeat 10
    [run-scenrios
    file-open "GP-Location-lowex.csv"
    file-print csv:to-string (list num-GPone-market-list num-GPone-office-list num-GPone-school-list num-GPone-leisure-list num-GPone-house-list
                                   num-GPtwo-market-list num-GPtwo-office-list num-GPtwo-school-list num-GPtwo-leisure-list num-GPtwo-house-list
                                  num-GPthree-market-list num-GPthree-office-list num-GPthree-school-list num-GPthree-leisure-list num-GPthree-house-list)
    ;file-open "GP-Transportation-lowex.csv"
    ;file-print csv:to-string (list  num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
    ;                                num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
    ;                                num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list)
    ]
   file-close-all
  ]
  if scenrios = "medium-exposure"
  [ repeat 10
    [run-scenrios
    file-open "GP-Location-midex.csv"
    file-print csv:to-string (list num-GPone-market-list num-GPone-office-list num-GPone-school-list num-GPone-leisure-list num-GPone-house-list
                                   num-GPtwo-market-list num-GPtwo-office-list num-GPtwo-school-list num-GPtwo-leisure-list num-GPtwo-house-list
                                   num-GPthree-market-list num-GPthree-office-list num-GPthree-school-list num-GPthree-leisure-list num-GPthree-house-list)
   ; file-open "GP-Transportation-midex.csv"
    ;file-print csv:to-string (list num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
     ;                               num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
      ;                              num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list)
    ]
   file-close-all
  ]
  if scenrios = "high-exposure"
  [ repeat 10
    [run-scenrios
    file-open "GP-Location-highex.csv"
    file-print csv:to-string (list num-GPone-market-list num-GPone-office-list num-GPone-school-list num-GPone-leisure-list num-GPone-house-list
                                   num-GPtwo-market-list num-GPtwo-office-list num-GPtwo-school-list num-GPtwo-leisure-list num-GPtwo-house-list
                                   num-GPthree-market-list num-GPthree-office-list num-GPthree-school-list num-GPthree-leisure-list num-GPthree-house-list)
   ; file-open "GP-Transportation-highex.csv"
    ;file-print csv:to-string (list  num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
      ;                              num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
     ;                               num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list)
    ]
   file-close-all
  ]

   if scenrios = "Scenario5"
  [ repeat 20
    [run-scenrios
     file-open "Scenario5.csv"
     file-print csv:to-string (list  num-GPone-bus-list num-GPone-metro-list num-GPone-walk-list num-GPone-bike-list num-GPone-car-list num-GPone-taxi-list
                                    num-GPtwo-bus-list num-GPtwo-metro-list num-GPtwo-walk-list num-GPtwo-bike-list num-GPtwo-car-list num-GPtwo-taxi-list
                                    num-GPthree-bus-list num-GPthree-metro-list num-GPthree-walk-list num-GPthree-bike-list num-GPthree-car-list num-GPthree-taxi-list)
    ]
   file-close
  ]

end

to sensitivity-analysis
  if scenrios = "non-exposure"
  [ set F-wellbeing-GPone 4   set F-wellbeing-GPtwo 3   set F-wellbeing-GPthree 2
    set T-speed-GPone     4   set T-speed-GPtwo     4   set T-speed-GPthree     4
    set T-cost-GPone      5   set T-cost-GPtwo      3   set T-cost-GPthree      1
    set F-risk-GPone      0   set F-risk-GPtwo      0   set F-risk-GPthree      0
    set T-risk-GPone      0   set T-risk-GPtwo      0   set T-risk-GPthree      0
    sensitivity-analysis-scenario
  ]
  if scenrios = "low-exposure"
  [ set F-wellbeing-GPone 4   set F-wellbeing-GPtwo 3   set F-wellbeing-GPthree 2
    set T-speed-GPone     4   set T-speed-GPtwo     4   set T-speed-GPthree     4
    set T-cost-GPone      5   set T-cost-GPtwo      3   set T-cost-GPthree      1
    set F-risk-GPone      1   set F-risk-GPtwo      1   set F-risk-GPthree      1
    set T-risk-GPone      1   set T-risk-GPtwo      1   set T-risk-GPthree      1
    sensitivity-analysis-scenario
  ]
  if scenrios = "medium-exposure"
  [ set F-wellbeing-GPone 4   set F-wellbeing-GPtwo 3   set F-wellbeing-GPthree 2
    set T-speed-GPone     4   set T-speed-GPtwo     4   set T-speed-GPthree     4
    set T-cost-GPone      5   set T-cost-GPtwo      3   set T-cost-GPthree      1
    set F-risk-GPone      3   set F-risk-GPtwo      3   set F-risk-GPthree      3
    set T-risk-GPone      3   set T-risk-GPtwo      3   set T-risk-GPthree      3
    sensitivity-analysis-scenario
  ]
  if scenrios = "high-exposure"
  [ set F-wellbeing-GPone 4   set F-wellbeing-GPtwo 3   set F-wellbeing-GPthree 2
    set T-speed-GPone     4   set T-speed-GPtwo     4   set T-speed-GPthree     4
    set T-cost-GPone      5   set T-cost-GPtwo      3   set T-cost-GPthree      1
    set F-risk-GPone      5   set F-risk-GPtwo      5   set F-risk-GPthree      5
    set T-risk-GPone      5   set T-risk-GPtwo      5   set T-risk-GPthree      5
    sensitivity-analysis-scenario
  ]
  if scenrios = "Scenario5"
  [ set F-wellbeing-GPone 4   set F-wellbeing-GPtwo 3   set F-wellbeing-GPthree 2
    set T-speed-GPone     4   set T-speed-GPtwo     4   set T-speed-GPthree     4
    set T-cost-GPone      1   set T-cost-GPtwo      1   set T-cost-GPthree      1
    set F-risk-GPone      5   set F-risk-GPtwo      5   set F-risk-GPthree      5
    set T-risk-GPone      5   set T-risk-GPtwo      5   set T-risk-GPthree      5
    sensitivity-analysis-scenario
  ]

end
;;=======================================================================================================================================
@#$#@#$#@
GRAPHICS-WINDOW
436
10
993
568
-1
-1
9.0
1
10
1
1
1
0
0
0
1
-30
30
-30
30
0
0
1
ticks
30.0

BUTTON
25
35
88
68
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
456
587
628
620
num-GPones
num-GPones
0
20
10.0
1
1
NIL
HORIZONTAL

BUTTON
121
35
184
68
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
216
478
389
511
roads-showing?
roads-showing?
0
1
-1000

BUTTON
227
36
308
69
one-step
one-step
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
437
568
1023
688
GPone
NIL
N of citizen
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"market" 1.0 0 -13345367 true "" "plot num-GPone-market "
"office" 1.0 0 -10899396 true "" "plot num-GPone-office"
"school" 1.0 0 -2674135 true "" "plot num-GPone-school"
"leisure" 1.0 0 -955883 true "" "plot num-GPone-leisure"
"house" 1.0 0 -7500403 true "" "plot num-GPone-house"

SLIDER
217
442
389
475
alpha
alpha
0
1
0.1
0.01
1
NIL
HORIZONTAL

BUTTON
323
36
401
69
NIL
one-day
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1008
12
1443
189
citiznes location
Ticks-each present 2 hrs
Number of agents
0.0
10.0
0.0
20.0
true
true
"" ""
PENS
"home" 1.0 0 -10899396 true "" "plot num-C-house"
"market" 1.0 0 -7500403 true "" "plot num-C-market"
"office" 1.0 0 -2674135 true "" "plot num-C-office"
"school" 1.0 0 -955883 true "" "plot num-C-school"
"leisure" 1.0 0 -6459832 true "" "plot num-C-leisure"

PLOT
436
687
1024
807
GPtwo
NIL
N of citizen
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Market" 1.0 0 -13345367 true "" "plot num-GPtwo-market"
"Office" 1.0 0 -10899396 true "" "plot num-GPtwo-office"
"School" 1.0 0 -2674135 true "" "plot num-GPtwo-school"
"Leisure" 1.0 0 -955883 true "" "plot num-GPtwo-leisure"
"House" 1.0 0 -7500403 true "" "plot num-GPtwo-house"

PLOT
436
808
1023
928
GPthree
NIL
N of citizen
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Market" 1.0 0 -13345367 true "" "plot num-GPthree-market"
"Office" 1.0 0 -10899396 true "" "plot num-GPthree-office"
"School" 1.0 0 -2674135 true "" "plot num-GPthree-school"
"Leisure" 1.0 0 -955883 true "" "plot num-GPthree-leisure"
"House" 1.0 0 -7500403 true "" "plot num-GPthree-house"

SLIDER
217
406
389
439
num-houses
num-houses
0
5
3.0
1
1
NIL
HORIZONTAL

SLIDER
27
442
199
475
num-GPtwos
num-GPtwos
0
20
10.0
1
1
NIL
HORIZONTAL

PLOT
1009
195
1444
382
Transportation mode selection
Steps
Number of agents 
0.0
730.0
0.0
22.0
true
true
"" ""
PENS
"bus" 1.0 0 -10899396 true "" "plot count citizens with [color = green]"
"metro" 1.0 0 -13345367 true "" "plot count citizens with [color = blue]"
"walk" 1.0 0 -2382653 true "" "plot count citizens with [color = lime]"
"bike" 1.0 0 -8630108 true "" "plot count citizens with [color = violet]"
"car" 1.0 0 -955883 true "" "plot count citizens with [color = orange]"
"taxi" 1.0 0 -1184463 true "" "plot count citizens with [color = yellow]"

BUTTON
21
130
131
163
Setup-test-turtle
setup-spatial-arrow
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
133
130
251
163
Test-risk-on-routine
go-spatial-arrow
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
25
351
205
384
hidden-test-agent?
hidden-test-agent?
0
1
-1000

TEXTBOX
25
95
452
121
---------------------------------------------------------------------------------------------\nSet up spatial risk value to routins:
11
0.0
1

TEXTBOX
22
386
458
404
----------------------------------------------------------------------------------------------
11
0.0
1

OUTPUT
21
204
405
303
11

BUTTON
254
130
401
163
Update-transportation-risk
update-spatialtransportation-risk
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
235
351
394
384
SR?
SR?
0
1
-1000

BUTTON
22
167
223
200
Other values of transportation pattern
out-print-transportation-pattern-value
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
231
167
406
200
Values of facilities
out-print-destination-value
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
26
406
198
439
num-GPones
num-GPones
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
27
477
199
510
num-GPthrees
num-GPthrees
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
26
312
203
345
percent-highest-risk
percent-highest-risk
0
100
10.0
1
1
%
HORIZONTAL

BUTTON
235
313
395
346
Updata spatial risk
setup-patches
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1009
392
1445
564
Exposure of citizens
Ticks-each 2 hrs
Exposure
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"GPones" 1.0 0 -14070903 true "" "plot mean [exposure] of GPones"
"GPtwos" 1.0 0 -13840069 true "" "plot mean [exposure] of GPtwos"
"GPthrees" 1.0 0 -2674135 true "" "plot mean [exposure] of GPthrees"

MONITOR
1047
576
1185
621
Avg P-market of GPones
mean [item 0 P-facility-next] of GPones
4
1
11

MONITOR
1185
576
1329
621
Avg P-school of GPones
mean ([item 1 P-facility-next ] of GPones)
4
1
11

MONITOR
1317
576
1460
621
Avg P-officel of GPones
mean [item 2 P-facility-next ] of GPones
4
1
11

MONITOR
1455
576
1590
621
Avg P-leisure of GPones
mean ([item 3 P-facility-next ] of GPones)
4
1
11

MONITOR
1047
622
1185
667
Avg P-market of GPtwos
mean ([item 0 P-facility-next ] of GPtwos)
4
1
11

MONITOR
1185
622
1329
667
Avg P-school of GPtwos
mean ([item 1 P-facility-next ] of GPtwos)
4
1
11

MONITOR
1318
622
1459
667
Avg P-office of GPtwos
mean ([item 2 P-facility-next ] of GPtwos)
4
1
11

MONITOR
1455
622
1590
667
Avg P-leisure of GPtwos
mean ([item 3 P-facility-next ] of GPtwos)
4
1
11

MONITOR
1047
667
1185
712
Avg P-market of GPthrees
mean ([item 0 P-facility-next ] of GPthrees)
4
1
11

MONITOR
1185
667
1339
712
Avg P-school of GPthrees
mean ([item 1 P-facility-next ] of GPthrees)
4
1
11

MONITOR
1318
667
1470
712
Avg P-officel of GPthrees
mean ([item 2 P-facility-next ] of GPthrees)
4
1
11

MONITOR
1455
667
1591
712
Avg P-leisure of GPthrees
mean ([item 3 P-facility-next ] of GPthrees)
4
1
11

MONITOR
1046
728
1175
773
Avg P-bus of GPones
mean ([item 0 P-transport-next ] of GPones)
4
1
11

MONITOR
1174
728
1307
773
Avg P-metro of GPones
mean ([item 1 P-transport-next ] of GPones)
4
1
11

MONITOR
1306
728
1440
773
Avg P-walk of GPones
mean ([item 2 P-transport-next ] of GPones)
4
1
11

MONITOR
1440
728
1572
773
Avg P-bike of GPones
mean ([item 3 P-transport-next ] of GPones)
4
1
11

MONITOR
1572
728
1699
773
Avg P-car of GPones
mean ([item 4 P-transport-next ] of GPones)
4
1
11

MONITOR
1699
728
1830
773
Avg P-taxi of GPones
mean ([item 4 P-transport-next ] of GPones)
4
1
11

MONITOR
1046
772
1175
817
Avg P-bus of GPtwos
mean ([item 0 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1174
772
1307
817
Avg of P-metro GPtwos
mean ([item 1 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1307
772
1441
817
Avg P-walk of GPtwos
mean ([item 2 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1441
772
1573
817
Avg P-bike of GPtwos
mean ([item 3 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1572
772
1699
817
Avg P-car of GPtwos
mean ([item 4 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1699
772
1830
817
Avg P-taxi of GPtwos
mean ([item 5 P-transport-next ] of GPtwos)
4
1
11

MONITOR
1046
816
1175
861
Avg P-bus of GPthrees
mean ([item 0 P-transport-next ] of GPthrees)
4
1
11

MONITOR
1174
816
1308
861
Avg P-metro of GPthrees
mean ([item 1 P-transport-next ] of GPthrees)
4
1
11

MONITOR
1307
816
1441
861
Avg P-walk of GPthrees
mean ([item 2 P-transport-next ] of GPthrees)
4
1
11

MONITOR
1440
816
1573
861
Avg P-bike of GPthrees
mean ([item 3 P-transport-next ] of GPthrees)
4
1
11

MONITOR
1572
816
1699
861
Avg P-car of GPthrees
mean ([item 4 P-transport-next ] of GPthrees)
4
1
11

MONITOR
1699
817
1830
862
Avg P-taxi of GPthrees
mean ([item 5 P-transport-next ] of GPthrees)
4
1
11

CHOOSER
90
611
201
656
F-wellbeing-GPone
F-wellbeing-GPone
0 1 2 3 4 5
4

CHOOSER
204
611
317
656
F-risk-GPone
F-risk-GPone
0 1 2 3 4 5
0

CHOOSER
91
657
201
702
T-Speed-GPone
T-Speed-GPone
0 1 2 3 4 5
4

CHOOSER
204
657
317
702
T-cost-GPone
T-cost-GPone
0 1 2 3 4 5
5

CHOOSER
318
657
423
702
T-risk-GPone
T-risk-GPone
0 1 2 3 4 5
0

CHOOSER
91
709
202
754
F-wellbeing-GPtwo
F-wellbeing-GPtwo
0 1 2 3 4 5
3

CHOOSER
204
709
318
754
F-risk-GPtwo
F-risk-GPtwo
0 1 2 3 4 5
0

CHOOSER
91
755
202
800
T-speed-GPtwo
T-speed-GPtwo
0 1 2 3 4 5
4

CHOOSER
204
755
318
800
T-cost-GPtwo
T-cost-GPtwo
0 1 2 3 4 5
3

CHOOSER
320
756
426
801
T-risk-GPtwo
T-risk-GPtwo
0 1 2 3 4 5
0

CHOOSER
92
808
203
853
F-wellbeing-GPthree
F-wellbeing-GPthree
0 1 2 3 4 5
2

CHOOSER
205
808
319
853
F-risk-GPthree
F-risk-GPthree
0 1 2 3 4 5
0

CHOOSER
93
854
204
899
T-speed-GPthree
T-speed-GPthree
0 1 2 3 4 5
4

CHOOSER
205
854
321
899
T-cost-GPthree
T-cost-GPthree
0 1 2 3 4 5
1

CHOOSER
322
854
427
899
T-risk-GPthree
T-risk-GPthree
0 1 2 3 4 5
0

TEXTBOX
66
560
339
578
Vaues weighting of different groups of citizens:\n
12
14.0
1

TEXTBOX
15
583
467
601
Select a score from 0-5, where 5 being the most important and 0 being of not important
11
0.0
1

TEXTBOX
16
646
104
664
Group One
11
0.0
1

TEXTBOX
19
748
169
766
Group two
11
0.0
1

TEXTBOX
17
845
167
863
Group three
11
0.0
1

TEXTBOX
13
574
450
605
---------------------------------------------------------------------------------------------------------
11
0.0
1

PLOT
1459
12
1860
162
Herfidahl-Index
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((num-C-house ^ 2 + num-C-market ^ 2 + num-C-office ^ 2 + num-C-school ^ 2 + num-C-leisure ^ 2)/(num-C-house + num-C-office + num-C-market + num-C-school + num-C-leisure)^ 2)"

PLOT
1866
11
2066
161
Herfidahl-Index-market
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((num-GPone-market ^ 2 + num-GPtwo-market ^ 2 + num-GPthree-market ^ 2 ) / (num-GPone-market + num-GPtwo-market + num-GPthree-market) ^ 2)"

PLOT
1866
163
2066
313
Herfidahl-Index-office
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((num-GPone-office ^ 2 + num-GPtwo-office ^ 2 + num-GPthree-office ^ 2 ) / (num-GPone-office + num-GPtwo-office + num-GPthree-office) ^ 2)"

PLOT
2071
11
2268
161
Herfidahl-Index-school
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((num-GPone-school ^ 2 + num-GPtwo-school ^ 2 + num-GPthree-school ^ 2 ) / (num-GPone-school + num-GPtwo-school + num-GPthree-school) ^ 2)"

PLOT
2069
162
2269
312
Herfidahl-Index-leisure
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((num-GPone-leisure ^ 2 + num-GPtwo-leisure ^ 2 + num-GPthree-leisure ^ 2 ) / (num-GPone-leisure + num-GPtwo-leisure + num-GPthree-leisure) ^ 2)"

PLOT
1459
164
1860
314
Dissimilarity index of citizens with/without car
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot  0.5 * (abs (((num-GPtwo-house + num-GPthree-house)/ 20) - (num-GPone-house / 10)) + abs (((num-GPtwo-office + num-GPthree-office)/ 20) - (num-GPone-office / 10)) + abs (((num-GPtwo-market + num-GPthree-market)/ 20) - (num-GPone-market / 10)) + abs (((num-GPtwo-school + num-GPthree-school)/ 20) - (num-GPone-school / 10)) + abs (((num-GPtwo-leisure + num-GPthree-leisure)/ 20) - (num-GPone-leisure / 10)) )"

CHOOSER
27
514
201
559
Scenrios
Scenrios
"non-exposure" "low-exposure" "medium-exposure" "high-exposure" "Scenario5"
0

BUTTON
215
514
389
554
sensitivity-analysis
sensitivity-analysis
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

app
false
0
Rectangle -7500403 true true 30 90 270 255
Line -16777216 false 270 90 270 255
Polygon -7500403 true true 15 90 285 90 210 15 90 15
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 45 150 75 180
Rectangle -16777216 true false 45 150 75 180
Rectangle -16777216 true false 90 150 120 180
Rectangle -16777216 true false 135 150 165 180
Rectangle -16777216 true false 180 150 210 180
Rectangle -16777216 true false 225 150 255 180
Rectangle -16777216 true false 45 195 75 225
Rectangle -16777216 true false 90 195 120 225
Rectangle -16777216 true false 135 195 165 225
Rectangle -16777216 true false 180 195 210 225
Rectangle -16777216 true false 225 195 255 225
Rectangle -16777216 true false 45 105 75 135
Rectangle -16777216 true false 90 105 120 135
Rectangle -16777216 true false 135 105 165 135
Rectangle -16777216 true false 180 105 210 135
Rectangle -16777216 true false 225 105 255 135
Line -16777216 false 15 90 285 90
Line -16777216 false 210 15 285 90

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

clock
true
0
Circle -7500403 true true 30 30 240
Polygon -16777216 true false 150 31 128 75 143 75 143 150 158 150 158 75 173 75
Circle -16777216 true false 135 135 30

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

leisure
false
0
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Rectangle -1184463 true false 75 75 225 240
Polygon -1184463 true false 105 120 120 105 135 120 150 105 165 120 180 105 195 120 210 105 210 120 105 120
Rectangle -1 true false 75 45 225 75
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Polygon -955883 false false 225 60 255 60 255 210 225 210 225 105
Rectangle -955883 false false 75 45 225 240

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

office
false
10
Rectangle -7500403 true false 75 45 270 150
Circle -13840069 true false 105 75 58
Circle -955883 false false 116 86 67
Polygon -13345367 true true 75 150 0 225 210 225 270 150
Circle -13345367 true true 105 90 30

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

person gpone
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person gptwo
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

school
false
0
Rectangle -7500403 true true 15 120 285 240
Polygon -7500403 true true 0 120 300 120 240 45 60 45 0 120
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 0 120 300 120

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

supermarket
false
6
Polygon -7500403 true false 0 150 195 150 255 60 60 60 0 150
Line -7500403 false 90 105 240 105
Line -7500403 false 240 105 195 150
Line -7500403 false 105 90 45 150
Line -13840069 true 45 150 45 225
Line -13345367 false 45 225 195 225
Line -1184463 false 195 150 195 225
Line -7500403 false 285 150 285 225
Line -7500403 false 195 225 300 225
Line -7500403 false 195 150 285 150
Line -13840069 true 45 150 195 150
Rectangle -11221820 true false 0 150 195 225
Rectangle -7500403 true false 45 180 150 225
Polygon -11221820 true false 135 60 75 150 90 150 150 60
Polygon -7500403 true false 255 60 195 150 300 150 255 60
Rectangle -7500403 true false 195 150 300 225
Line -16777216 false 195 150 195 225
Line -16777216 false 195 150 300 150
Line -16777216 false 0 150 195 150
Polygon -11221820 true false 75 60 15 150 30 150 90 60
Polygon -11221820 true false 105 60 45 150 60 150 120 60
Polygon -11221820 true false 165 60 105 150 120 150 180 60
Polygon -11221820 true false 195 60 135 150 150 150 210 60
Polygon -11221820 true false 225 60 165 150 180 150 240 60

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-spatial risk change" repetitions="3" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-adaptation rate change" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>one-day</go>
    <timeLimit steps="90"/>
    <metric>num-C-house</metric>
    <metric>num-C-market</metric>
    <metric>num-C-office</metric>
    <metric>num-C-school</metric>
    <metric>num-C-leisure</metric>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-risk0" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-risk1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-risk5" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-risk3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost0risk5" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost1risk5" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost3risk5" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost5risk5" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost0risk3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost1risk3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost3risk3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost5risk3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost0risk1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost1risk1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost3risk1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost5risk1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost0risk0" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost1risk0" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost3risk0" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-cost5risk0" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-nonexposure" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-lowexposure" repetitions="100" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-medianexposure" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-highexposure" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="90"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-highEX(arrival)" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-MEDIANEX(ARRIVAL)" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-lOWex(ARRIVAL)" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-NONex(ARRIVAL)" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-nonexposure" repetitions="1" runMetricsEveryStep="true">
    <setup>setup
setup-spatial-arrow
go-spatial-arrow
update-spatialtransportation-risk</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="T-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percent-highest-risk">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPthree">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="roads-showing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPones">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-risk-GPone">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPtwo">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-houses">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPthree">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPthree">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hidden-test-agent?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPtwo">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-cost-GPone">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SR?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-wellbeing-GPone">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPtwos">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-GPthrees">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="F-risk-GPtwo">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-speed-GPthree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="T-Speed-GPone">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

curved link
1.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

middle line
0.0
-0.2 1 2.0 2.0
0.0 0 0.0 1.0
0.2 1 2.0 2.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

thick line
0.0
-0.2 1 1.0 0.0
0.0 0 0.0 1.0
0.2 1 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
