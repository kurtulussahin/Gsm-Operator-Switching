globals
[
  
  UnitsOfTime ;total tick
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;  OPERATOR ATTRIBUTES  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
 
  num-operators
  Number_Of_Turkcell_Customer 
  Number_Of_Vodafone_Customer
  Number_Of_Avea_Customer
  
  prestige_Of_Turkcell 
  prestige_Of_Vodafone 
  prestige_Of_Avea     
  
    
  ;price_factor_of_Turkcell   ;slider at interface. 
  ;price_factor_of_Vodafone   ;slider at interface
  ;price_factor_of_Avea       ;slider at interface
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;  VARIABLES FOR CHURN RATE CALCULATIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  churn_Rate_Turkcell  ;her ay abonelerin yüzde kaçı operatörü terketti. gerçek istetistik % 3 civarında
  churn_Rate_Vodafone
  churn_Rate_Avea
  average_churn_Rate_Turkcell
  average_churn_Rate_Vodafone
  average_churn_Rate_Avea
  total_churn_Rate_Turkcell
  total_churn_Rate_Vodafone
  total_churn_Rate_Avea
   
  churn_Number_Turkcell ;her ay kaç abone operatörü terketti
  churn_Number_Vodafone
  churn_Number_Avea
  
  ;;;;;;;;;;;;;;;;;;;;;;;; END  VARIABLES FOR CHURN RATE CALCULATIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;; END OPERATOR ATTRIBUTES  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
  
  
  
  
  
]

turtles-own
[
  
  
  operator_type ;0=turkcell yellow, 1=vodafone red, 2=avea blue
  income
  age
  invoice_type ; 0=invoice, 1=prepaid
  last_time_changed ;if user doent chance operator at tick, this variable increase 1
  commitment_time ;if there is no commitment it is 0, if not it is shows commitment time as month
  
  
  total_switch_cost ; it contains different operator switching cost , commitment time cost , last time changed cost , income and age cost
  
  
  ; values for these variables are calculated in set demand method.
  speech_demand 
  message_demand
  internet_demand
  
  ; the importance factor given by the customer to each of speech , message and internet.
  speech_factor
  message_factor
  internet_factor
  
  turkcell_utility
  vodafone_utility
  avea_utility
  
  ;different_operator_switch_cost ;slider at interface
  
  turkcell_switching_probablity
  vodafone_switching_probablity
  avea_switching_probablity
  
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;     SETUP   ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup 

clear-all

set num-operators 3
set UnitsOfTime 360 
create-turtles 100
[
  set sıze 1 
  setxy random-xcor random-ycor  
]

set-brand-effect ; sets operator's brand value 

set-operator
set-demand
set-age
set-income
set-invoice-type
set-commitment-time
set-factor
  
       
  
show "Baslangicta Olan"
count-turtles
reset-ticks

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  END SETUP  ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;      GO     ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to go
   
  ask turtles [ switch ]
  
  calculate-churn-rate ; the percentage of customers who leaves their operator is calculated at each tick through this method.
  
  reset-churn-number
  ;set-demand-each-tick
  
  tick
  show word "Ticks: " ticks 
  count-turtles
   
  if ticks >= UnitsOfTime [stop] ; kaç kez switching yapılacağını sayıyor 
   
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;    END GO   ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;    SWITCH   ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to switch
 
   set turkcell_utility calculate-total-turkcell-utility
   set vodafone_utility calculate-total-vodafone-utility
   set avea_utility calculate-total-avea-utility
   
   
   calculate-switching-probablity
     
   ;customer changes his/her operator based on the probablity
   change-operator
      
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  END SWITCH  ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; PARAMETER SETTING FUNCTIONS ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Real income values are set for each of ten group.

to set-income 
  ask turtles
  [
    let randomIncome random 100
    
    ifelse(randomIncome < 10 ) 
    [      
      set income 2114 
    ]
    [    
      ifelse(randomIncome < 20 ) 
      [  
        set income 3523        
      ]
      [
        ifelse(randomIncome < 30 ) 
        [  
          set income 4631          
        ]
        [
          ifelse(randomIncome < 40 ) 
          [            
            set income 5739          
          ]
          [
            ifelse(randomIncome < 50 ) 
            [   
              set income 6947
            ]
            [
              ifelse(randomIncome < 60 ) 
              [
                set income 8256 
              ]
              [
                ifelse(randomIncome < 70 ) 
                [
                  set income 9760                  
                ]
                [
                  ifelse(randomIncome < 80 ) 
                  [                    
                    set income 11880                    
                  ]
                  [
                    ifelse(randomIncome < 90 ) 
                    [
                      set income 15505
                    ]
                    [
                      if(randomIncome < 100 ) 
                      [
                        set income 32420 
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end


; This method sets real age values for age groups.
to set-age
  ask turtles
  [
    let randomAgeProbability random-float 1
    
    ifelse(randomAgeProbability < 0.40)
 
    [
      set age (random 20) + 10
    ]
    [
      ifelse(randomAgeProbability < 0.75)
      
      [
        set age (random 20) + 30
      ]
      [
        ifelse(randomAgeProbability < 0.94)
        
        [
          set age (random 20) + 50
        ]
        [
          if(randomAgeProbability < 1)
          
          [
            set age (random 20) + 70
          ]         
        ]
      ]     
    ] 
  ]
end



to set-invoice-type
  ask turtles
  [
    
    
    if (operator_type = 0)
    [
      let randomNumber random 100
      
      ifelse(randomNumber < 60)
      [
        set invoice_type 1
      ]
      [
        set invoice_type 0
      ]
    ]
    
    
    if (operator_type = 1)
    [
      
      let randomNumber random 100
      ifelse(randomNumber < 61)
      [
        set invoice_type 1
      ]
      [
        set invoice_type 0
      ]
    ]
    
    if (operator_type = 2)
    [
      
      let randomNumber random 100
      ifelse(randomNumber < 54)
      [
        set invoice_type 1
      ]
      [
        set invoice_type 0
      ]
    ] 
  ]
 
end



to set-commitment-time
   ask turtles
  [
    if(invoice_type = 0)
    [
      set commitment_time random 13
    ]
  
  ]
end


to set-demand
  ask turtles
  [
    if(operator_type = 0)
    [
      set speech_demand random-normal 186 10  ;turkcell kullanıcılarına ortalama 186 dakika olacak şekilde, 10 standard devieyşınla kullanıcılara konuşma süresi set ediyor.  
    ]
    
    if(operator_type = 1)
    [
      set speech_demand random-normal 271 10  ;vodafone kullanıcılarına ortalama 271 dakika olacak şekilde, 10 standard devieyşınla kullanıcılara konuşma süresi set ediyor.
    ]
    
    if(operator_type = 2)
    [
      set speech_demand random-normal 260 10  ;avea kullanıcılarına ortalama 260 dakika olacak şekilde, 10 standard devieyşınla kullanıcılara konuşma süresi set ediyor.
    ]
      
    if(operator_type = 0)
    [
      set message_demand random-normal 140 10  
      
    ]
    
    if(operator_type = 1)
    [
      set message_demand random-normal 296 10  
    ]
    
    if(operator_type = 2)
    [
      set message_demand random-normal 221 10  
    ]
    
  
   
    let randomNumberInternet random-float 100
      
    ifelse(randomNumberInternet < 39.41)
    [
      set internet_demand 0  
    ]
    [
      ifelse(randomNumberInternet < (39.41 + 7.89))
      [
        set internet_demand 30  
      ]
      [
        
        ifelse(randomNumberInternet < (39.41 + 7.89 + 5.68))
        [
          set internet_demand 75  
        ]
        [
          
          ifelse(randomNumberInternet < (39.41 + 7.89 + 5.68 + 9.72))
          [
            set internet_demand 175  
          ]
          [
            
            
            ifelse(randomNumberInternet < (39.41 + 7.89 + 5.68 + 9.72 + 21.48))
            [
              set internet_demand 625  
            ]
            [
              
              ifelse(randomNumberInternet < (39.41 + 7.89 + 5.68 + 9.72 + 21.48 + 14.16))
              [
                set internet_demand 2500  
              ]
              [
                
                if(randomNumberInternet < (39.41 + 7.89 + 5.68 + 9.72 + 21.48 + 14.16 + 1.66))
                [
                  set internet_demand 6000 
                ]          
              ]              
            ]            
          ]
        ]
       ]       
    ]     
  ]
  
end

; customers' demand changes with this function
to set-demand-each-tick
  ask turtles
  [
    ; bu kısım değiştirilecek 
    
      let randomNumberSpeachChange random ((speech_demand * 0.2) * 2)
    
      set speech_demand speech_demand + ( (speech_demand * 0.2 ) - randomNumberSpeachChange)  ;at each tick, speech demand changes between -30, +30
      
      if (speech_demand < 0)
      [ set speech_demand 0 ]
      
     ; --------------------------------------------------------
      
      let randomNumberMessageChange random ((message_demand * 0.5) * 2)
    
      set message_demand message_demand + ( (message_demand * 0.5) - randomNumberMessageChange)  ;at each tick, message demand changes between -30, +30
      
      if (message_demand < 0)
      [ set message_demand 0 ]
      
     ; ------------------------------------------------------------
      
      let randomNumberInternetChange random ((internet_demand * 0.4) * 2)
    
      set internet_demand internet_demand + ( (internet_demand * 0.4) - randomNumberInternetChange)  ;at each tick, internet demand changes between -100, +100
      
      if (internet_demand < 0)
      [ set internet_demand 0 ]
    
  ]
  
end


to set-factor
  ask turtles
  [
    
  let randomNumberForSpeech random-float 1
  
  set speech_factor randomNumberForSpeech  ; speach factor between 0-1 a float number
  
  let randomNumberForMessage random-float 0.3
  
  set message_factor randomNumberForMessage
  
  let randomNumberForInternet random-float 0.7
  
  set internet_factor randomNumberForInternet
  ;---------------------------------------------
  
  ]
end



to set-operator
  
ask turtles      ; operator types are set to the customers at real percentage. 
[
  let randomNumber random 9999
  
  ifelse(randomNumber < 5052) ;turkcell
  [
    set operator_type 0
    set color yellow
  ]
  [
    ifelse(randomNumber < (5052 + 2861)) ;Vodafone
    [
       set operator_type 1
       set color red
    ]
    [
      set operator_type 2 ;avea
      set color blue 
    ]
    
  ] 
]  
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; END PARAMETER SETTING FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UTILITY CALCULATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; SPEECH UTILITY FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;speech_demand , speech_factor are attributes of agents

to-report calculate-turkcell-speech-utility
  
   report  (speech_factor * (sqrt speech_demand)) - (price_factor_of_Turkcell * (sqrt speech_demand))
end

to-report calculate-vodafone-speech-utility
  
  report  (speech_factor * (sqrt speech_demand)) - (price_factor_of_Vodafone * (sqrt speech_demand)) 
  
end

to-report calculate-avea-speech-utility
  
   report (speech_factor * (sqrt speech_demand)) - (price_factor_of_Avea * (sqrt speech_demand)) 
 
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; MESSAGE UTILITY FUNCTIONS ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;message_demand , message_factor are attributes of agents

to-report calculate-turkcell-message-utility
 
   report  (message_factor * (sqrt message_demand)) - (price_factor_of_Turkcell * (sqrt message_demand)) 
 
end

to-report calculate-vodafone-message-utility
  
  report  (message_factor * (sqrt message_demand)) - (price_factor_of_Vodafone * (sqrt message_demand))
end

to-report calculate-avea-message-utility
  
   report (message_factor * (sqrt message_demand)) - (price_factor_of_Avea * (sqrt message_demand))
 
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; INTERNET UTILITY FUNCTIONS ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;internet_demand , internet_factor are attributes of agents

to-report calculate-turkcell-internet-utility
 
   report  (internet_factor * (sqrt internet_demand)) - (price_factor_of_Turkcell * (sqrt internet_demand)) 
end

to-report calculate-vodafone-internet-utility
  
  report  (internet_factor * (sqrt internet_demand)) - (price_factor_of_Vodafone * (sqrt internet_demand)) 
end

to-report calculate-avea-internet-utility
  
   report (internet_factor * (sqrt internet_demand)) - (price_factor_of_Avea * (sqrt internet_demand)) 
 
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; TOTAL UTILITY FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to-report calculate-total-turkcell-utility

  calculate-switch-cost ; it calculates total switch cost
  
   ifelse (operator_type = 0)
   [
      report calculate-turkcell-speech-utility + calculate-turkcell-message-utility + calculate-turkcell-internet-utility + prestige_of_Turkcell 
 
     
   ]
   [
      report calculate-turkcell-speech-utility + calculate-turkcell-message-utility + calculate-turkcell-internet-utility + prestige_of_Turkcell   - total_switch_cost
   ]
   
      
end

to-report calculate-total-vodafone-utility
   
   ifelse (operator_type = 1)
   [
      report calculate-vodafone-speech-utility + calculate-vodafone-message-utility + calculate-vodafone-internet-utility + prestige_of_Vodafone
  
     
   ]
   [
      report calculate-vodafone-speech-utility + calculate-vodafone-message-utility + calculate-vodafone-internet-utility + prestige_of_Vodafone - total_switch_cost
   ]

          
end

to-report calculate-total-avea-utility

   ifelse (operator_type = 2)
   [
      report calculate-avea-speech-utility + calculate-avea-message-utility + calculate-avea-internet-utility + prestige_of_Avea
     
   ]
   [
      report calculate-avea-speech-utility + calculate-avea-message-utility + calculate-avea-internet-utility + prestige_of_Avea - total_switch_cost
   ]

   
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END UTILITY CALCULATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;         FUNCTIONS        ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; utility hesaplandıktan sonra probabililty log it mantığıyla hesaplanıyor 

to calculate-switching-probablity
   
   set turkcell_switching_probablity ( (e ^ turkcell_utility) / ( (e ^ turkcell_utility) +  (e ^ vodafone_utility) +  (e ^ avea_utility) ))
   
   set vodafone_switching_probablity ( (e ^ vodafone_utility) / ((e ^ turkcell_utility) + (e ^ vodafone_utility) + (e ^ avea_utility) ))
   
   set avea_switching_probablity ( (e ^ avea_utility) / ((e ^ turkcell_utility) + (e ^ vodafone_utility) + (e ^ avea_utility) ))
   
end
   

; her operatorden ayrılan kişi sayısını sıfırlar.

to reset-churn-number
    
  set churn_Number_Turkcell 0
  set churn_Number_Vodafone 0
  set churn_Number_Avea 0
  
end
  
   
; random number ve probablity nin alacağı değerlere göre operator değişiyor veya aynı kalıyor. 
; değişim gerçekleşirse eski operatorun churn numberı artıyor .

to change-operator
     
     let randomNumber (random-float 1)
     
     ifelse (randomNumber <= turkcell_switching_probablity ) 
     [ 
       
       set last_time_changed last_time_changed + 1
       if(operator_type = 0)
       [
         if(commitment_time > 0)
         [
           set commitment_time commitment_time - 1
         ]
       ]
       
       
       if(operator_type = 1)
       [ 
         set churn_Number_Vodafone churn_Number_Vodafone + 1
         set last_time_changed 0;
        
         ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek 
         ;---------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
         ;----------------------------------
         
       ]
       
       
       if(operator_type = 2)
       [ 
         set churn_Number_Avea churn_Number_Avea + 1 
         set last_time_changed 0;
     
      ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek       
      ;--------------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
       ;------------------------------------
       
       ]
       
       set color yellow
       set operator_type 0
       
         
     ]
  
     [
   
       ifelse (randomNumber < turkcell_switching_probablity + vodafone_switching_probablity )
         [ 
           
           set last_time_changed last_time_changed + 1
           if(operator_type = 0)
           [
             set commitment_time commitment_time - 1
           ]
           
           
           if(operator_type = 0)
           [ 
             set churn_Number_Turkcell churn_Number_Turkcell + 1
             set last_time_changed 0;
        ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek      
        ;--------------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
       ;---------------------------
             
           ]
       
           if(operator_type = 2)
           [ 
             set churn_Number_Avea churn_Number_Avea + 1
             set last_time_changed 0;
       
        ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek              
        ;--------------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
       ;---------------------------
           ]
           
           set color red
           set operator_type 1
           
         ]
         
         [
           ;if (randomNumber <= turkcell_probability + vodafone_probability + avea_probability )
           
           
           set last_time_changed last_time_changed + 1
           if(operator_type = 0)
           [
             set commitment_time commitment_time - 1
           ]
           
           if(operator_type = 0)
           [ 
             set churn_Number_Turkcell churn_Number_Turkcell + 1
             set last_time_changed 0;
      
      ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek         
      ;--------------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
       ;---------------------------
           ]
       
           if(operator_type = 1)
           [ 
             set churn_Number_Vodafone churn_Number_Vodafone + 1
             set last_time_changed 0;
   
      
       ; eğer kullanıcı faturalı hat sahibiyse operatorunu değiştirdiği zaman belli bir oranda taahutlü hattı sececek       
       ;--------------------------------------
         if(operator_type = 0)
         [
           let randomNumberInvoceProbability random 100
           if(randomNumberInvoceProbability < 90)
           [
             set commitment_time 12
           ]
         ]
       ;---------------------------
           ]
           
           set color blue
           set operator_type 2
                    
         ]   
   ]
  
end
   
  
   
   
to calculate-churn-rate ;her ay abonelerin yüzde kaçı operatörü terketti. gerçek istetistik % 3 civarında
  
  set churn_Rate_Turkcell (churn_Number_Turkcell / ( Number_Of_Turkcell_Customer + 1)) * 100
  set churn_Rate_Vodafone (churn_Number_Vodafone /( Number_Of_Vodafone_Customer + 1)) * 100
  set churn_Rate_Avea  (churn_Number_Avea / (Number_Of_Avea_Customer + 1)) * 100
  
  if(ticks > 30)
  [
  set total_churn_Rate_Turkcell total_churn_Rate_Turkcell + churn_Rate_Turkcell
  set total_churn_Rate_Avea total_churn_Rate_Avea + churn_Rate_Avea
  set total_churn_Rate_Vodafone total_churn_Rate_Vodafone + churn_Rate_Vodafone
  
  
  set average_churn_Rate_Turkcell total_churn_Rate_Turkcell / ( ticks - 30)
  set average_churn_Rate_Avea total_churn_Rate_Avea / ( ticks - 30)
  set average_churn_Rate_Vodafone total_churn_Rate_Vodafone / ( ticks - 30)
  ]
  
end



to calculate-switch-cost
  
  set total_switch_cost different_operator_switch_cost
  
  if(invoice_type = 0)
  [
     set total_switch_cost total_switch_cost + (different_operator_switch_cost * 0.2)
  ]
  
  ;;;;;;;;;;;;;;; SWITCH COST RELATED TO COMMITMENT TIME;;;;;;;;;;;
  if(commitment_time < 7)
  [
    
    set total_switch_cost total_switch_cost + (commitment_time * 0.1)
    
  ]
  if(commitment_time > 6)
  [
    set total_switch_cost total_switch_cost + ((12 - commitment_time) * 0.1)
    
  ]
  ;;;;;;;;;;;;;;; END SWITCH COST RELATED TO COMMITMENT TIME;;;;;;;;;;;
  
  
  ;;;;;;;;;;;;;;; SWITCH COST RELATED TO LAST TIME CHANGED ;;;;;;;;;;;
  if(last_time_changed < 13 )
  [ 
  set total_switch_cost total_switch_cost + ( (12 - last_time_changed) * 0.1)
  ]  
  ;;;;;;;;;;;;;;; END SWITCH COST RELATED TO LAST TIME CHANGED ;;;;;;;;;;;
  
  
  ;;;;;;;;;;;;;;; SWITCH COST RELATED TO INCOME ;;;;;;;;;;;
  ;set total_switch_cost total_switch_cost + (30 / income)
  
  
  ;;;;;;;;;;;;;;; SWITCH COST RELATED TO AGE  ;;;;;;;;;;;
  set total_switch_cost total_switch_cost + (age * 0.01)

  
end

to count-turtles
  
  set Number_Of_Turkcell_Customer count turtles with [operator_type = 0]
  set Number_Of_Vodafone_Customer count turtles with [operator_type = 1]
  set Number_Of_Avea_Customer count turtles with [operator_type = 2]
  
  
  show word "Turkcell abone sayısı: "  Number_Of_Turkcell_Customer
  show word "Vodafone abone sayısı: " Number_Of_Vodafone_Customer
  show word "Avea abone sayısı     : " Number_Of_Avea_Customer

 print_churn_rate
       
end

;;;;;;;;;;;;;; BRAND IMAGE OF OPREATOR ;;;;;;;;;;;
to set-brand-effect
  
 
 ;set  prestige_Of_Turkcell 47
 ;set  prestige_Of_Vodafone 24
 ;set  prestige_Of_Avea  18
 
 set  prestige_Of_Turkcell 45
 set  prestige_Of_Vodafone 25
 set  prestige_Of_Avea  20

end
   
   
 to print_average-speech
   
   show word "Turkcell konuşma ortalaması: "  mean [ speech_demand] of turtles with [operator_type = 0]
   show word "Vodafone konuşma ortalaması: "  mean [ speech_demand] of turtles with [operator_type = 1]
   show word "Avea konuşma ortalaması: "  mean [ speech_demand] of turtles with [operator_type = 2]
   show word "Total konuşma ortalaması: "  mean [ speech_demand] of turtles
   show "******"
   show word "Turkcell mesajlaşma ortalaması: "  mean [ message_demand] of turtles with [operator_type = 0]
   show word "Vodafone mesajlaşma ortalaması: "  mean [ message_demand] of turtles with [operator_type = 1]
   show word "Avea mesajlaşma ortalaması: "  mean [ message_demand] of turtles with [operator_type = 2]
   show word "Total mesajlaşma ortalaması: "  mean [ message_demand] of turtles
   show "******"
   show word "Turkcell internet ortalaması: "  mean [ internet_demand] of turtles with [operator_type = 0]
   show word "Vodafone internet ortalaması: "  mean [ internet_demand] of turtles with [operator_type = 1]
   show word "Avea internet ortalaması: "  mean [ internet_demand] of turtles with [operator_type = 2]
   show word "Total internet ortalaması: "  mean [ internet_demand] of turtles
   show "******"
   
   
   
 end
   
  to print_churn_rate
    
    
   show word "Turkcell churn: "  churn_Rate_Turkcell
   show word "Vodafone churn: "  churn_Rate_Vodafone
   show word "Avea churn: "  churn_Rate_Avea
   
   show word "Turkcell average churn: "  average_churn_Rate_Turkcell
   show word "Vodafone average churn: "  average_churn_Rate_Vodafone
   show word "Avea average churn: "  average_churn_Rate_Avea
   
   ;show word "average churn: "  mean [ speech_demand] of turtles
    
    
    
    
  end
   
   
   ;; set demand değişecek
   ; change operatorde taahut kısmında yuzde 90 istimal olayı var 
   ; BRAND İMAGE İLE OYNA 
   
   
   
   
   
   
   
   
   
   
@#$#@#$#@
GRAPHICS-WINDOW
275
10
662
470
14
16
13.0
1
10
1
1
1
0
1
1
1
-14
14
-16
16
0
0
1
ticks
30.0

TEXTBOX
25
53
175
81
GSM OPERATOR SWITCHING MODELING\n
11
0.0
1

BUTTON
99
96
162
129
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

BUTTON
18
96
86
129
NIL
SETUP
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
670
12
1049
256
Number of Customers
Time
Number
0.0
24.0
0.0
600.0
true
true
"" ""
PENS
"Turkcell" 1.0 0 -1184463 true "" "plot count turtles with [color = yellow]"
"Vodafone" 1.0 0 -2674135 true "" "plot count turtles with [color = red]"
"Avea" 1.0 0 -13345367 true "" "plot count turtles with [color = blue]"

SLIDER
17
169
219
202
price_factor_of_Turkcell
price_factor_of_Turkcell
0
1.5
0.96
0.01
1
NIL
HORIZONTAL

SLIDER
18
207
218
240
price_factor_of_Vodafone
price_factor_of_Vodafone
0
1
0.427
0.001
1
NIL
HORIZONTAL

SLIDER
18
249
217
282
price_factor_of_Avea
price_factor_of_Avea
0
1
0.35
0.01
1
NIL
HORIZONTAL

PLOT
1058
12
1334
249
Churn Rate
NIL
NIL
0.0
0.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 0 -1184463 true "" "plot churn_Rate_Turkcell"
"pen-1" 1.0 0 -2674135 true "" "plot churn_Rate_Vodafone"
"pen-2" 1.0 0 -13345367 true "" "plot churn_Rate_Avea"

SLIDER
13
300
242
333
different_operator_switch_cost
different_operator_switch_cost
0
10
2.3
0.05
1
NIL
HORIZONTAL

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
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>average_churn_Rate_Turkcell</metric>
    <metric>average_churn_Rate_Vodafone</metric>
    <metric>average_churn_Rate_Avea</metric>
    <steppedValueSet variable="price_factor_of_Vodafone" first="0.2" step="0.1" last="0.7"/>
    <steppedValueSet variable="price_factor_of_Avea" first="0.1" step="0.1" last="0.5"/>
    <steppedValueSet variable="price_factor_of_Turkcell" first="0.5" step="0.1" last="1.5"/>
    <steppedValueSet variable="different_operator_switch_cost" first="1" step="0.5" last="6"/>
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

@#$#@#$#@
0
@#$#@#$#@
