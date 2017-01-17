;;This model is an extension of Robby the Robot.
;;Modifications were made to the original code to produce this model, and hence, it is not 100% our work.

breed [individuals individual]
individuals-own 
[
  chromosome
  fitness
  scaled-fitness
  allele-distribution
]

breed [rabbits rabbit]
rabbits-own [strategy]

breed [carrots carrot]
breed [wolves wolf]
wolves-own[step food location]

globals 
[
  wolf-penalty 
  move-penalty
  sit-penalty
  carrot-density
  carrot-reward 
  wall-penalty 
  pick-up-penalty
  best-chromosome
  best-fitness
  step-counter
  visuals?
  min-fit
  max-fit
  x-offset
  tournament-size
  num-environments-for-fitness
  num-actions-per-environment
]

to setup
  clear-all
  reset-ticks
  ask patches [set pcolor white]
  set visuals? false
  initialize-globals
  set-default-shape rabbits "rabbit"
  set-default-shape carrots "carrot"
  set-default-shape individuals "rabbit"
  set-default-shape wolves "wolf 2"
  create-individuals population-size 
  [
    set color 19
    set size .5
    set chromosome n-values 243 [random-action]
    set allele-distribution map [occurrences ? chromosome] ["move-north" "move-east" "move-south" "move-west" "move-random" "stay-put" "pick-up-carrot"] 
  ]
  calculate-population-fitnesses
  let best-individual max-one-of individuals [fitness]
  ask best-individual 
  [
    set best-chromosome chromosome
    set best-fitness fitness
    output-print (word "generation " ticks ":")
    output-print (word "  best fitness = " fitness)
    output-print (word "  best strategy: " map action-symbol chromosome)
  ]
  display-fitness best-individual
  plot-pen-up
  plotxy -1 0
  set-plot-y-range (precision best-fitness 0) (precision best-fitness 0) + 3
  plot best-fitness
  plot-pen-down
end

to initialize-globals
  set move-penalty 2
  set wolf-penalty 500
  set carrot-density 0.5
  set sit-penalty 1
  set wall-penalty 5
  set carrot-reward 10
  set pick-up-penalty 1
  set min-fit  -200
  set max-fit 400
  set x-offset 0
  set tournament-size 15
  set num-environments-for-fitness 20
  set num-actions-per-environment 100
end

to distribute-carrots
  ask carrots [ die ]
  ask patches with [random-float 1 < carrot-density] 
  [
    sprout-carrots 1 
    [ 
      set color orange 
      if not visuals? [ht]
    ]
  ]
end

to draw-grid
  clear-drawing
  ask patches 
  [
    sprout 1 
    [
      set shape "square"
      set color blue + 4
      stamp
      die
    ]
  ]
end

to-report random-action
  report one-of ["move-north" "move-east" "move-south" "move-west"
                 "move-random" "stay-put" "pick-up-carrot"]
end

to-report action-symbol [action]
  if action = "move-north"  [ report "↑" ]
  if action = "move-east"   [ report "→" ]
  if action = "move-south"  [ report "↓" ]
  if action = "move-west"   [ report "←" ]
  if action = "move-random" [ report "+" ]
  if action = "stay-put"    [ report "x" ]
  if action = "pick-up-carrot" [ report "●" ]
end

to-report action-number [action]
  if action = "move-north"  [ report 1 ]
  if action = "move-east"   [ report 2 ]
  if action = "move-south"  [ report 3 ]
  if action = "move-west"   [ report 4 ]
  if action = "move-random" [ report 5 ]
  if action = "stay-put"    [ report 6 ]
  if action = "pick-up-carrot" [ report 7 ]
end

to go
  create-next-generation.
  calculate-population-fitnesses
  let best-individual max-one-of individuals [fitness]
  display-fitness best-individual
  ask best-individual 
  [
    set best-chromosome chromosome
    set best-fitness fitness
    output-print (word "generation " (ticks + 1) ":")
    output-print (word "  best fitness = " fitness)
    output-print (word "  best strategy: " map action-symbol chromosome)
  ]
  check-energy
  move-wolf
  check-encounter-wolf
  tick
end

to go-n-generations
  if ticks < number-of-generations [go]
end

to display-fitness [best-individual]
  ask individuals [ set label "" set color scale-color red scaled-fitness 1 -.1]
  let mid-x max-pxcor / 2
  let mid-y max-pycor / 2
  ask best-individual 
  [
    setxy ((precision scaled-fitness 2) * max-pxcor + x-offset) mid-y 
    setxy ( scaled-fitness * max-pxcor + x-offset) mid-y 
    ask other individuals 
    [
      setxy ((precision scaled-fitness 2) * max-pxcor + x-offset) mid-y 
      setxy ( scaled-fitness * max-pxcor + x-offset) mid-y 
      set heading one-of [0 180] 
      fd chromosome-distance self myself
      ]
  ]
  ask best-individual [set heading 90 set label-color black set label (word "Best:" (precision fitness  2)) ]
end


to initialize-rabbit [s]
  ask rabbits [ die ]
  create-rabbits 1 
  [
    set label 0
    ifelse visuals? 
    [
      set color white
      set pcolor grey 
      pen-down 
      set label-color black
    ]
    [set hidden? true]
    set strategy s
  ]
end

to initialize-wolf
  ask wolves [ die ]
  create-wolves 1 
  [
    ifelse visuals? 
    [ set color brown ]
    [set hidden? true] 
    setxy 4 9
    set step 0
  ]
end
  
 

to create-next-generation.
  let old-generation (turtle-set individuals)
  let crossover-count population-size / 2
  repeat crossover-count 
  [
    let parent1 max-one-of (n-of tournament-size old-generation) [fitness]
    let parent2 max-one-of (n-of tournament-size old-generation) [fitness]
    let child-chromosomes crossover ([chromosome] of parent1) ([chromosome] of parent2)
    ask parent1 
    [
      hatch 1 
      [
        rt random 360 fd random-float 3.0
        set chromosome item 0 child-chromosomes
        set allele-distribution map [occurrences ? chromosome] ["move-north" "move-east" "move-south" "move-west" "move-random" "stay-put" "pick-up-carrot"] 
      ]
    ]
    ask parent2 
    [
      hatch 1 
      [
        rt random 360 fd random-float 3.0
        set chromosome item 1 child-chromosomes
        set allele-distribution map [occurrences ? chromosome] ["move-north" "move-east" "move-south" "move-west" "move-random" "stay-put" "pick-up-carrot"] 
      ]
    ]
  ]
  ask old-generation [ die ]
  ask individuals [ mutate ]
end

to calculate-population-fitnesses
  foreach sort individuals 
  [
    let current-individual ?
    let score-sum 0
    repeat num-environments-for-fitness 
    [
      initialize-rabbit [chromosome] of current-individual
      distribute-carrots
      initialize-wolf
      repeat num-actions-per-environment 
      [
        ask rabbits [ run item state strategy ]
      ]
      set score-sum score-sum + sum [label] of rabbits
    ]
    ask current-individual 
    [
      set fitness score-sum / num-environments-for-fitness
      ifelse fitness < min-fit 
        [set scaled-fitness 0] 
        [set scaled-fitness (fitness + (abs min-fit)) / (max-fit + (abs min-fit))]
    ]
  ]
end

to-report crossover [chromosome1 chromosome2]
  let split-point 1 + random (length chromosome1 - 1)
  report list (sentence (sublist chromosome1 0 split-point)
                        (sublist chromosome2 split-point length chromosome2))
              (sentence (sublist chromosome2 0 split-point)
                        (sublist chromosome1 split-point length chromosome1))
end

to mutate
  set chromosome map [ifelse-value (random-float 1 < mutation-rate)
                        [random-action] [?]]
                     chromosome
end

to-report state
  let north patch-at 0 1
  let east patch-at 1 0
  let south patch-at 0 -1
  let west patch-at -1 0
  report 
  ifelse-value (any? wolves-on north) 
  [162]
  [
    ifelse-value (any? carrots-on north) 
    [81] 
    [0]
  ]
  +
  ifelse-value (any? wolves-on east ) 
  [54] 
  [
    ifelse-value (any? carrots-on east ) 
    [27] 
    [0]
  ]
  +
  ifelse-value (any? wolves-on south)
  [18]
  [
    ifelse-value (any? carrots-on south) 
    [9] 
    [0]
  ]
  +
  ifelse-value (any? wolves-on west ) 
  [6]
  [
    ifelse-value (any? carrots-on west ) 
    [ 3] 
    [0]
  ]
  +
  ifelse-value (any? carrots-here)
  [1]
  [0]
end

to move-north  
  set heading   0  
  ifelse can-move? 1 
  [
    fd 1 
    set label label - move-penalty
  ] 
  [ 
    set label label - move-penalty 
  ]  
end
to move-east   
  set heading  90  
  ifelse can-move? 1 
  [
    fd 1 
    set label label - move-penalty
  ] 
  [ 
    set label label - move-penalty 
  ]
end
to move-south  
  set heading 180  
  ifelse can-move? 1 
  [
    fd 1 
    set label label - move-penalty
  ] 
  [
    set label label - move-penalty 
  ] 
end
to move-west   
  set heading 270  
  ifelse can-move? 1 
  [ 
    fd 1 
    set label label - move-penalty
  ] 
  [
    set label label - move-penalty 
  ]
end
to move-random run one-of ["move-north" "move-south" "move-east" "move-west"] end
to stay-put    
  set label label - sit-penalty 
end

to pick-up-carrot
  ifelse any? carrots-here
    [ set label label + carrot-reward ]
    [ set label label - pick-up-penalty ]
  ask carrots-here 
  [
    if visuals? 
    [
      set color gray
    ]
    die
  ]
end

to move-wolf
  ask wolves
  [
      ifelse step mod 3 > 0
      [
        ifelse any? rabbits in-radius 3
        [
          set food [who] of (rabbits in-radius 3)
          ifelse(any? rabbits-here)
          []
          [
            set location towards rabbit item 0 food
            if location = 315 or location > 315 or location < 45
            [set heading 0]
            if location = 45 or location < 135
            [set heading 90]
            if location = 135 or location < 225
            [set heading 180]
            if location = 225 or location < 315
            [set heading 270]
            forward 1
          ]
        ]
        [
          set heading one-of[0 90 180 270]                             
          forward 1
        ]
      ]
      []
      set step step + 1
    ]
end
 
to check-encounter-wolf
  ask wolves
  [
    ifelse (any? rabbits-here)
    [
      ask rabbits 
      [
        set color red 
        set label label - wolf-penalty
      ]
    ]
    []
  ]
end
    
to check-energy
  ask rabbits
  [
    if label < -300
    [die]
    if color = red
    [die]
  ]
end

to setup-rabbit-visuals
  if ticks = 0 [ stop ]
  clear-output
  ask individuals [hide-turtle]
  set visuals? true
  draw-grid
  distribute-carrots
  initialize-wolf
  initialize-rabbit best-chromosome
  set step-counter 1
  output-print "Setting up a new random carrot distribution"
end

to setup-individual-visuals
  if visuals? 
  [
    clear-output
    clear-drawing
    ask carrots [die]
    ask rabbits [die]
    ask wolves [die]
    ask patches [set pcolor white]
    ask individuals [show-turtle]
    set visuals? false
    let best-individual max-one-of individuals [fitness]
    display-fitness best-individual
    ask best-individual
    [
      output-print (word "generation " ticks ":")
      output-print (word "  best fitness = " fitness)
      output-print (word "  best strategy: " map action-symbol chromosome)
    ]
  ]
end

to run-trial-step
  if ticks = 0 [ stop ]
  if step-counter > num-actions-per-environment [set step-counter 0 set visuals? false ]
  if step-counter = 1 [output-print "Stepping through the best strategy found at this generation"]
  ask rabbits 
  [
      let current-action item state strategy
      run current-action
      ifelse step-counter != num-actions-per-environment 
      [output-print (word step-counter ")  " current-action " (" action-symbol current-action "), score = " label)]
      [output-print (word step-counter ")  " current-action " (" action-symbol current-action "), final-score = " label)]
      ;; we're not using the tick counter here, so force a view update
      display
      set step-counter step-counter + 1
  ]
  check-energy
  move-wolf
  check-encounter-wolf
end

to-report occurrences [x a-list]
  report reduce
    [ifelse-value (?2 = x) [?1 + 1] [?1]] (fput 0 a-list)
end

to-report chromosome-distance [individual1 individual2]
  let max-dist  273 * sqrt 2
  let dist2 reduce + (map [(?1  - ?2) ^ 2] [allele-distribution] of individual1 [allele-distribution] of individual2)
  let dist-candidate max-pxcor * sqrt dist2 / ( max-dist / 10)
  report ifelse-value (dist-candidate > max-pxcor) [max-pxcor] [dist-candidate]
end
@#$#@#$#@
GRAPHICS-WINDOW
365
16
675
347
-1
-1
30.0
1
10
1
1
1
0
1
1
1
0
9
0
9
1
1
1
Generations
90.0

SLIDER
8
186
180
219
population-size
population-size
20
500
100
2
1
NIL
HORIZONTAL

SLIDER
185
186
357
219
mutation-rate
mutation-rate
0
1
0.05
.001
1
NIL
HORIZONTAL

BUTTON
9
62
82
95
Set Up
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

PLOT
8
232
309
432
Best Fitness
Generation
Best Fitness
0.0
5.0
-30.0
1.0
true
false
"" ""
PENS
"best" 1.0 0 -16777216 true "" "plot best-fitness"

OUTPUT
769
10
1200
491
9

TEXTBOX
640
383
772
497
\"↑\" =   move-north  \n \"→\"  = move-east \n \"↓\"  = move-south  \n \"←\"  = move-west\n \"+\"   = move-random\n \"x\"    =  stay-put   \n\"●\"    =  pick-up-carrot
12
103.0
1

TEXTBOX
9
26
258
58
Speed up speed slider or turn off view updates for faster response.
11
0.0
1

BUTTON
320
460
509
493
Step Through Best Strategy
run-trial-step
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
161
136
332
169
number-of-generations
number-of-generations
1
1000
250
1
1
NIL
HORIZONTAL

BUTTON
8
136
155
169
Go for n-generations
go-n-generations
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
367
355
517
373
Low Fitness
11
18.0
1

TEXTBOX
483
355
633
373
Medium Fitness
11
13.0
1

TEXTBOX
615
354
765
372
High Fitness
11
10.0
1

BUTTON
320
421
513
454
View Bunny's Environment
setup-rabbit-visuals
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
518
466
639
497
Watch the Bunny move one step at a time.  
10
0.0
1

TEXTBOX
521
403
657
455
Setup and view the environment by randomly distributing carrots throughout the world. 
10
0.0
1

TEXTBOX
320
379
641
421
After running the GA,  watch the Bunny use the best evolved strategy:
14
95.0
1

BUTTON
8
104
108
137
Go Forever
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

TEXTBOX
681
222
831
278
More similar \nto best strategy
11
0.0
1

TEXTBOX
682
59
832
101
Less similar\nto best strategy
11
0.0
1

TEXTBOX
681
287
831
329
Less similar \nto best strategy
11
0.0
1

TEXTBOX
686
181
836
199
Population
14
95.0
1

TEXTBOX
682
128
832
156
More similar\nto best strategy
11
0.0
1

TEXTBOX
9
10
159
28
Run the GA:
14
95.0
1

BUTTON
8
445
189
478
View Strategies
setup-individual-visuals
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
194
449
329
477
Return to a view of the strategies.
10
0.0
1

@#$#@#$#@
## WHAT IS IT?


## HOW IT WORKS


## HOW TO USE IT


## THINGS TO NOTICE


## THINGS TO TRY


## EXTENDING THE MODEL


## NETLOGO FEATURES


## RELATED MODELS


## CREDITS AND REFERENCES


## HOW TO CITE


## COPYRIGHT AND LICENSE
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

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

carrot
true
0
Polygon -955883 true false 75 90 150 240 210 90 75 90
Polygon -14835848 true false 75 90 60 60 90 75 105 45 120 75 150 30 165 60 180 45 180 75 225 60 210 90

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

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

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 5 4 294 295

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

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

wolf 2
false
0
Rectangle -7500403 true true 195 106 285 150
Rectangle -7500403 true true 195 90 255 105
Polygon -7500403 true true 240 90 217 44 196 90
Polygon -16777216 true false 234 89 218 59 203 89
Rectangle -1 true false 240 93 252 105
Rectangle -16777216 true false 242 96 249 104
Rectangle -16777216 true false 241 125 285 139
Polygon -1 true false 285 125 277 138 269 125
Polygon -1 true false 269 140 262 125 256 140
Rectangle -7500403 true true 45 120 195 195
Rectangle -7500403 true true 45 114 185 120
Rectangle -7500403 true true 165 195 180 270
Rectangle -7500403 true true 60 195 75 270
Polygon -7500403 true true 45 105 15 30 15 75 45 150 60 120

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.3
@#$#@#$#@
setup repeat 5 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
