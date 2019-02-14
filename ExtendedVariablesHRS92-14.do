

set more off
capture clear
capture clear matrix
capture clear mata
capture log close
set maxvar 20000

use "/Users/lindsayjacobs/Desktop/10_31_Reworked Data File.dta"
tsset hhidpn wave

/*This section created new variables that track accumulated work periods, reverse
retirement, etc. constructed from existing variables. These will be used for descriptives 
and also the estimation sample */

set varabbrev off
*indicate being in the wave, based on having non-missing age
gen inwave =.
replace inwave=1 if (rWagey_b_ !=.)

*number of waves responded
egen inwTOT = total(inwave), by(hhidpn)
order inwTOT, after(inwave)
label var inwTOT "total number of WAVEs observed"

//indicate first wave observed
by hhidpn (wave), sort: gen byte inwFIRST = sum(inwave)== 1

//indicate wave run
gen inwRun =.
replace inwRun=cond(inwave==1&(wave==1|inwFIRST==1),1,0)
by hhidpn: replace inwRun = L.inwRun+1 if inwave==1&(wave!=1|inwFIRST!=1)


*number of waves working for pay
egen rWworkTOT = total(rWwork_), by(hhidpn)
label var rWworkTOT "total number of rWwork=1"

*indicates whether obs for at least two periods and working in at least one
gen rWinwTOT2workTOT1=.
replace rWinwTOT2workTOT1=1 if inwTOT>=2&rWworkTOT>=1
replace rWinwTOT2workTOT1=0 if rWinwTOT2workTOT1==.
label var rWinwTOT2workTOT1 "indicates whether observed for at least two periods and working in at least one"
label define inwTOT2work1 1 "1.obs>=2 and work>=1" 0 "0.obs<2 and/or work<1"
label values rWinwTOT2workTOT1 inwTOT2work1 

*indicates whether obs for at least five periods and working in at least one
gen rWinwTOT5workTOT1=.
replace rWinwTOT5workTOT1=1 if inwTOT>=5&rWworkTOT>=1
replace rWinwTOT5workTOT1=0 if rWinwTOT5workTOT1==.
label var rWinwTOT5workTOT1 "indicates whether observed for at least five periods and working in at least one"
label define inwTOT5work1 1 "1.obs>=5 and work>=1" 0 "0.obs<5 and/or work<1"
label values rWinwTOT5workTOT1 inwTOT5work1 

*create age category; helpful for descriptives
gen rWagey_m_CAT=.
replace rWagey_m_CAT=1 if rWagey_m_<50
replace rWagey_m_CAT=2 if rWagey_m_>49&rWagey_m_<55
replace rWagey_m_CAT=3 if rWagey_m_>54&rWagey_m_<60
replace rWagey_m_CAT=4 if rWagey_m_>59&rWagey_m_<65
replace rWagey_m_CAT=5 if rWagey_m_>64&rWagey_m_<70
replace rWagey_m_CAT=6 if rWagey_m_>69&rWagey_m_<75
replace rWagey_m_CAT=7 if rWagey_m_>74&rWagey_m_<80
replace rWagey_m_CAT=8 if rWagey_m_>79&rWagey_m_<85
replace rWagey_m_CAT=9 if rWagey_m_>84&rWagey_m_<90
replace rWagey_m_CAT=10 if rWagey_m_>89&rWagey_m_<150
label define ageyCAT 1 "1.<49" 2 "2.50-54" 3 "3.55-59" 4 "4.60-64" 5 "5.65-69" 6 "6.70-74" 7 "7.75-79" 8 "8.80-84" 9 "9.85-89" 10 "10.>90"
label values rWagey_m_CAT ageyCAT

* age at which respondent retires, minimum retirement age reported, and years since retirement
gen rWretage=.
replace rWretage=rWretyr-rabyear //change back to rWretyr _
label var rWretage "retirement age: rWretyr-rabyear"
egen rWretageMIN = min(rWretage), by(hhidpn)
label var rWretageMIN "lowest retirement age the individual lists"
gen rWretageYRSAGO=.
replace rWretageYRSAGO=rWagey_b_-rWretageMIN
label var rWretageYRSAGO "number of years since retirement"

* create retirement age category
gen rWretageCAT=.
replace rWretageCAT=1 if rWretageMIN<50
replace rWretageCAT=2 if rWretageMIN>49&rWretageMIN<55
replace rWretageCAT=3 if rWretageMIN>54&rWretageMIN<60
replace rWretageCAT=4 if rWretageMIN>59&rWretageMIN<65
replace rWretageCAT=5 if rWretageMIN>64&rWretageMIN<70
replace rWretageCAT=6 if rWretageMIN>69&rWretageMIN<75
replace rWretageCAT=7 if rWretageMIN>74&rWretageMIN<80
replace rWretageCAT=8 if rWretageMIN>79&rWretageMIN<85
replace rWretageCAT=9 if rWretageMIN>84&rWretageMIN<90
replace rWretageCAT=10 if rWretageMIN>89&rWretageMIN<150
label values rWretageCAT ageyCAT

* change in rWsayret, "considers self retired"
gen rWsayretLAST=.
by hhidpn, sort: replace rWsayretLAST= rWsayret_[_n-1]
gen rWsayretCH=.
replace rWsayretCH=1 if rWsayret_==0&rWsayretLAST==0
replace rWsayretCH=2 if rWsayret_==0&rWsayretLAST==1
replace rWsayretCH=3 if rWsayret_==0&rWsayretLAST==2
replace rWsayretCH=4 if rWsayret_==1&rWsayretLAST==0
replace rWsayretCH=5 if rWsayret_==1&rWsayretLAST==1
replace rWsayretCH=6 if rWsayret_==1&rWsayretLAST==2
replace rWsayretCH=7 if rWsayret_==2&rWsayretLAST==0
replace rWsayretCH=8 if rWsayret_==2&rWsayretLAST==1
replace rWsayretCH=9 if rWsayret_==2&rWsayretLAST==2
label define sayretCH 1 "1.notnot" 2 "2.complnot" 3 "3.partnot" 4 "4.notcompl" 5 "5.complcompl" 6 "6.partcompl" 7 "7.notpart" 8 "8.complpart" 9 "9.partpart"
label values rWsayretCH sayretCH
label var rWsayretCH "retirement status transitions: last period to current period"

* next and last period working and transition
gen rWworkNEXT=.
by hhidpn, sort: replace rWworkNEXT= rWwork_[_n+1]
label var rWworkNEXT "rWwork next period"
gen rWworkLAST=.
by hhidpn, sort: replace rWworkLAST= rWwork_[_n-1]
label var rWworkLAST "rWwork last period"
gen rWworkCH=.
replace rWworkCH=1 if rWworkLAST==1&rWwork_==0
replace rWworkCH=2 if rWworkLAST==1&rWwork_==1
replace rWworkCH=3 if rWworkLAST==0&rWwork_==0
replace rWworkCH=4 if rWworkLAST==0&rWwork_==1
label define workCH 1 "1.worknot" 2 "2.workwork" 3 "3.notnot" 4 "4.notwork"
label values rWworkCH workCH
label var rWworkCH "participation status: last period to current period"
* spouse
gen sWworkNEXT=.
by hhidpn, sort: replace sWworkNEXT= sWwork_[_n+1]
label var sWworkNEXT "sWwork next period"
gen sWworkLAST=.
by hhidpn, sort: replace sWworkLAST= sWwork_[_n-1]
label var sWworkLAST "sWwork last period"
gen sWworkCH=.
replace sWworkCH=1 if sWworkLAST==1&sWwork_==0
replace sWworkCH=2 if sWworkLAST==1&sWwork_==1
replace sWworkCH=3 if sWworkLAST==0&sWwork_==0
replace sWworkCH=4 if sWworkLAST==0&sWwork_==1
label values sWworkCH workCH
label var sWworkCH "participation status: last period to current period"

//identify respondents with at least one instance of reverse retirement
//... based on change in rWsayret
gen rWrevret=.
replace rWrevret=1 if rWsayretCH==2|rWsayretCH==3|rWsayretCH==8
replace rWrevret=0 if rWsayretCH==1|rWsayretCH==4|rWsayretCH==5|rWsayretCH==6|rWsayretCH==7|rWsayretCH==9
label var rWrevret "period of reverse retirement: 1 if compl to not, part to not, compl to part"
label define revret 1 "1.revret" 0 "0.norev"
label values rWrevret revret
//... based on change in rWwork
gen rWrevwork=.
replace rWrevwork=1 if rWworkCH==4
replace rWrevwork=0 if rWworkCH==1|rWworkCH==2|rWworkCH==3
label var rWrevwork "period of reverse rWwork: 1 not to work, 0 if work-work, not-not, or work-not"
label define revwork 1 "1.revwork" 0 "0.norevwork"
label values rWrevwork revwork
//spouse
gen sWrevwork=.
replace sWrevwork=1 if sWworkCH==4
replace sWrevwork=0 if sWworkCH==1|sWworkCH==2|sWworkCH==3
label var sWrevwork "period of reverse sWwork: 1 not to work, 0 if work-work, not-not, or work-not"
label values sWrevwork revwork


//how many times is reverse ret observed for individuals
//... based on change in rWsayret
by hhidpn, sort: egen float rWrevretOCC=total(rWrevret)
label var rWrevretOCC "occurences of reverse ret for individual"
//... based on change in rWwork
by hhidpn, sort: egen float rWrevworkOCC=total(rWrevwork)
label var rWrevworkOCC "occurences of reverse participation for individual"
//spouse
by hhidpn, sort: egen float sWrevworkOCC=total(sWrevwork)
label var sWrevworkOCC "occurences of reverse participation for individual"

//retirement satisfaction last period
gen rWretsatLAST=.
by hhidpn, sort: replace rWretsatLAST= rWretsat_[_n-1]
label values rWretsatLAST RETSAT
label var rWretsatLAST "rWretsat last period"
gen rWryrcmpLAST=.
by hhidpn, sort: replace rWryrcmpLAST= rWryrcmp_[_n-1]
label values rWryrcmpLAST RYRCMP
label var rWryrcmpLAST "rWryrcmp last period"

//group service and operator occupations together
//longest occupation
gen rWjlocc_COMBINE=.
replace rWjlocc_COMBINE=rWjlocc_
replace rWjlocc_COMBINE=59 if rWjlocc_==5|rWjlocc_==6|rWjlocc_==7|rWjlocc_==8|rWjlocc_==9
replace rWjlocc_COMBINE=1416 if rWjlocc_==14|rWjlocc_==15|rWjlocc_==16
label define jloccCOMBINE 1 "1.managerial specialty oper" 2 "2.prof specialty opr/tech sup" 3 "3.sales" 4 "4.clerical/admin supp" 59 "59.services" 10 "10.farming/forestry/fishing" 11 "11.mechanics/repair" 12 "12.constr trade/extractors" 13 "13.precision production" 1416 "1416.operators" 17 "17. member of armed forces"
label values rWjlocc_COMBINE jloccCOMBINE
label var rWjlocc_COMBINE "longest occupation held with services and operators combined"
//current occupation
gen rWjcocc_COMBINE=.
replace rWjcocc_COMBINE=rWjcocc_
replace rWjcocc_COMBINE=59 if rWjcocc_==5|rWjcocc_==6|rWjcocc_==7|rWjcocc_==8|rWjcocc_==9
replace rWjcocc_COMBINE=1416 if rWjcocc_==14|rWjcocc_==15|rWjcocc_==16
label define jcoccCOMBINE 1 "1.managerial specialty oper" 2 "2.prof specialty opr/tech sup" 3 "3.sales" 4 "4.clerical/admin supp" 59 "59.services" 10 "10.farming/forestry/fishing" 11 "11.mechanics/repair" 12 "12.constr trade/extractors" 13 "13.precision production" 1416 "1416.operators" 17 "17. member of armed forces"
label values rWjcocc_COMBINE jcoccCOMBINE
label var rWjcocc_COMBINE "current occupation held with services and operators combined"

//group marital statuses
gen rWmstat_COMBINE=.
replace rWmstat_COMBINE=1 if rWmstat_==1|rWmstat_==2|rWmstat_==3
replace rWmstat_COMBINE=2 if rWmstat_==4|rWmstat_==5|rWmstat_==6
replace rWmstat_COMBINE=3 if rWmstat_==7
replace rWmstat_COMBINE=4 if rWmstat_==8
label define mstatCOMBINE 1 "1.married/partnered" 2 "2.separated/divorced" 3 "3.widowed" 4 "4.never married"
label values rWmstat_COMBINE mstatCOMBINE 

//last period health
by hhidpn, sort: gen rWshltLAST=rWshlt_[_n-1]
label values rWshltLAST SHLT
by hhidpn, sort: gen sWshltLAST=sWshlt_[_n-1]
label values sWshltLAST SHLT

//health change category (combines degrees of worseness or betterness)
gen rWshltc_CAT=.
replace rWshltc_CAT=1 if (rWshltc_==-4|rWshltc_==-3|rWshltc_==-2|rWshltc_==-1)
replace rWshltc_CAT=2 if (rWshltc_==0)
replace rWshltc_CAT=3 if (rWshltc_==4|rWshltc_==3|rWshltc_==2|rWshltc_==1)
label define shltcCAT3 1 "1.better" 2 "2.same" 3 "3.worse"
label values rWshltc_CAT shltcCAT3
//for spouse
gen sWshltc_CAT=.
replace sWshltc_CAT=1 if (sWshltc_==-4|sWshltc_==-3|sWshltc_==-2|sWshltc_==-1)
replace sWshltc_CAT=2 if (sWshltc_==0)
replace sWshltc_CAT=3 if (sWshltc_==4|sWshltc_==3|sWshltc_==2|sWshltc_==1)
label values rWshltc_CAT shltcCAT3

//health change category 2, additionally combines "Same" and Better"
gen rWshltc_CAT2=.
replace rWshltc_CAT2=0 if (rWshltc_==-4|rWshltc_==-3|rWshltc_==-2|rWshltc_==-1|rWshltc_==0)
replace rWshltc_CAT2=1 if (rWshltc_==4|rWshltc_==3|rWshltc_==2|rWshltc_==1)
label define shltcCAT2 0 "0.samebetter" 1 "1.worse"
label values rWshltc_CAT2 shltcCAT2

//expected retirement age
gen rWEXPretage=rWrplnya_-rabyear
label var rWEXPretage "expecter retirement age: rWrplnya-rabyear"

//indicate if longest industry is ever reported as being Public Administration
gen PubAdminLIND=.
replace PubAdminLIND=1 if rWjlind_==13
replace PubAdminLIND=0 if PubAdminLIND==.
egen PubAdminLINDev= total(PubAdminLIND), by(hhidpn)
label var PubAdminLINDev ">0 if ever public admin"

//make a binary health variable
gen rWshlt_BINA=.
replace rWshlt_BINA=1 if rWshlt_==1|rWshlt_==2|rWshlt_==3
replace rWshlt_BINA=0 if rWshlt_==4|rWshlt_==5
label define shltBINA 0 "0.fair/poor" 1 "1.excl/verygd/gd"
label values rWshlt_BINA shltBINA


//combine good, very good, and excellent health
gen rWshlt_COMB=.
replace rWshlt_COMB=1 if rWshlt_==1|rWshlt_==2|rWshlt_==3
replace rWshlt_COMB=2 if rWshlt_==4
replace rWshlt_COMB=3 if rWshlt_==5
label define shltCOMB 1 "1.excl/vg/g" 2 "2.fair" 3 "3.poor"
label values rWshlt_COMB shltCOMB
order rWshlt_COMB, after(rWshlt_)

//last period combined health
by hhidpn, sort: gen rWshlt_COMBLAST=rWshlt_COMB[_n-1]
label values rWshlt_COMBLAST shltCOMB
////next period combined health
by hhidpn, sort: gen rWshlt_COMBNEXT=rWshlt_COMB[_n+1]
label values rWshlt_COMBNEXT shltCOMB

//experience
gen rWexper=.
replace rWexper=rWagey_m_-raedyrs-6
gen rWexperSQ=.
replace rWexperSQ=rWexper*rWexper

//age squared
gen rWagey_mSQ=rWagey_m_*rWagey_m_
gen rWagey_mSQ001=.001*rWagey_mSQ

//create hours per year
gen rWjhoursyear=(rWjweeks_)*(rWjhours_+rWjhour2_) if rWjhours_!=0&rWjweeks_!=0
replace rWjhoursyear=(rWjweeks_)*(rWjhours_) if rWjhour2_==.w
replace rWjhoursyear=0 if rWjhours_==0&rWjweeks_==0


//whether one is working for pay in later waves
gen rWworkLD1=.
by hhidpn, sort: replace rWworkLD1= rWwork_[_n+1]
label var rWworkLD1 "rWwork next period"
label values rWworkLD1 WORK
gen rWworkLD2=.
by hhidpn, sort: replace rWworkLD2= rWwork_[_n+2]
label var rWworkLD2 "rWwork 2 periods out"
label values rWworkLD2 WORK
gen rWworkLD3=.
by hhidpn, sort: replace rWworkLD3= rWwork_[_n+3]
label var rWworkLD3 "rWwork 3 periods out"
label values rWworkLD3 WORK
gen rWworkLD4=.
by hhidpn, sort: replace rWworkLD4= rWwork_[_n+4]
label var rWworkLD4 "rWwork 4 periods out"
label values rWworkLD4 WORK
gen rWworkLD5=.
by hhidpn, sort: replace rWworkLD5= rWwork_[_n+5]
label var rWworkLD5 "rWwork 5 periods out"
label values rWworkLD5 WORK
gen rWworkLD6=.
by hhidpn, sort: replace rWworkLD6= rWwork_[_n+6]
label var rWworkLD6 "rWwork 6 periods out"
label values rWworkLD6 WORK
gen rWworkLD7=.
by hhidpn, sort: replace rWworkLD7= rWwork_[_n+7]
label var rWworkLD7 "rWwork 7 periods out"
label values rWworkLD7 WORK
gen rWworkLD8=.
by hhidpn, sort: replace rWworkLD8= rWwork_[_n+8]
label var rWworkLD8 "rWwork 8 periods out"
label values rWworkLD8 WORK
gen rWworkLD9=.
by hhidpn, sort: replace rWworkLD9= rWwork_[_n+9]
label var rWworkLD9 "rWwork 9 periods out"
label values rWworkLD9 WORK
gen rWworkLD10=.
by hhidpn, sort: replace rWworkLD10= rWwork_[_n+10]
label var rWworkLD10 "rWwork 10 periods out"
label values rWworkLD10 WORK

//create binary rev. ret.: rWrev---OCC_BIN, 0 of 0 RR occurrences and 1 if 1+ RR occurrences
gen rWrevworkOCC_BIN=.
replace rWrevworkOCC_BIN=0 if rWrevworkOCC==0
replace rWrevworkOCC_BIN=1 if rWrevworkOCC>0
gen rWrevretOCC_BIN=.
replace rWrevretOCC_BIN=0 if rWrevretOCC==0
replace rWrevretOCC_BIN=1 if rWrevretOCC>0

//create binary variable for rWjstres:
gen rWjstresBIN=.
replace rWjstresBIN=1 if rWjstres_==1|rWjstres_==2
replace rWjstresBIN=0 if rWjstres_==3|rWjstres_==4
label var rWjstresBIN "0 if not stressful, 1 if stressful"
label define jstresBIN 0 "0.not stressful" 1 "1.stressful"
label values rWjstresBIN jstresBIN
// rWjstresBIN_LGn:
gen rWjstresBIN_LG1=.
by hhidpn, sort: replace rWjstresBIN_LG1=rWjstresBIN[_n-1]
label values rWjstresBIN_LG1 jstresBIN
label var rWjstresBIN_LG1 "0 if not stressful last, 1 if stressful last"
gen rWjstresBIN_LG2=.
by hhidpn, sort: replace rWjstresBIN_LG2=rWjstresBIN[_n-2]
label values rWjstresBIN_LG2 jstresBIN
label var rWjstresBIN_LG2 "0 if not stressful lag2, 1 if stressful lag2"
gen rWjstresBIN_LG3=.
by hhidpn, sort: replace rWjstresBIN_LG3=rWjstresBIN[_n-3]
label values rWjstresBIN_LG3 jstresBIN
label var rWjstresBIN_LG3 "0 if not stressful lag3, 1 if stressful lag3"


//generate proportion of wave working
gen rWworkPROP=.
replace rWworkPROP=rWworkTOT/inwTOT
label var rWworkPROP "proportion of waves for which rWwork_==1"


//generate total hours per week
gen rWjhourswkTOT=rWjhours_+rWjhour2_ if rWjhours_!=0
replace rWjhourswkTOT=rWjhours_ if rWjhour2_==.w
label var rWjhourswkTOT "=rWjhours+rWjhours"

/*

//create months not working prior to interview
//first: put r_jlasty+r_jlastm into days since 1/1/1960 (which is units for variable r_iwbeg)
gen r_jlastworkdays=(r_jlasty-1960)*365.25+r_jlastm*30.45
label var r_jlastworkdays "day stopped working (in days since  1/1/1960)"
gen r_jdayssincestop=r_iwbeg-r_jlastworkdays
label var r_jdayssincestop "days since stopped working"
//second: months since stopped working
gen r_monthsstopwork=ceil(r_jdayssincestop/30.45)
replace r_monthsstopwork=. if r_monthsstopwork<1
label var r_monthsstopwork "months since stopped working up to interview"

//months spent not working
//caution: these figures only exist for those who reported not working in the last interview (since only they were asked when they stopped working)
//looking into the raw HRS, we may be able to get time not working in between two waves
//first: get day when current work started (in days since 1/1/60)
gen r_jcurtendaystart=r_iwbeg-(365.25*r_jcten) if r_jcten<2&r_jcten>0
label var r_jcurtendaystart "day current job began if tenure is less than 2 years (days since 1960)"
//second: current tenure in months
gen r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-1]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-2]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-3]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-4]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-5]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-6]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-7]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-8]
replace r_monthsnotwork=r_jcurtendaystart-r_jlastworkdays[_n-9]
replace r_monthsnotwork=ceil(r_monthsnotwork/30.45)
label var r_monthsnotwork "months not working (if r_workLAST==0 and r_jcten less than 2 years)"
//



*/





//whether there is a change in work status in future and past waves
gen rWworkCH_LD1=.
by hhidpn, sort: replace rWworkCH_LD1= rWworkCH[_n+1]
label var rWworkCH_LD1 "rWworkCH next period"
label values rWworkCH_LD1 workCH
gen rWworkCH_LD2=.
by hhidpn, sort: replace rWworkCH_LD2= rWworkCH[_n+2]
label var rWworkCH_LD2 "rWworkCH two periods out"
label values rWworkCH_LD2 workCH
gen rWworkCH_LD3=.
by hhidpn, sort: replace rWworkCH_LD3= rWworkCH[_n+3]
label var rWworkCH_LD3 "rWworkCH three periods out"
label values rWworkCH_LD3 workCH
gen rWworkCH_LD4=.
by hhidpn, sort: replace rWworkCH_LD4= rWworkCH[_n+4]
label var rWworkCH_LD4 "rWworkCH four periods out"
label values rWworkCH_LD4 workCH
gen rWworkCH_LG1=.
by hhidpn, sort: replace rWworkCH_LG1= rWworkCH[_n-1]
label var rWworkCH_LG1 "rWworkCH last period"
label values rWworkCH_LG1 workCH
gen rWworkCH_LG2=.
by hhidpn, sort: replace rWworkCH_LG2= rWworkCH[_n-2]
label var rWworkCH_LG2 "rWworkCH two periods prior"
label values rWworkCH_LG2 workCH
gen rWworkCH_LG3=.
by hhidpn, sort: replace rWworkCH_LG3= rWworkCH[_n-3]
label var rWworkCH_LG3 "rWworkCH three periods prior"
label values rWworkCH_LG3 workCH
gen rWworkCH_LG4=.
by hhidpn, sort: replace rWworkCH_LG4= rWworkCH[_n-4]
label var rWworkCH_LG4 "rWworkCH four periods prior"
label values rWworkCH_LG4 workCH


//divide into FT-PT based on hours worked per week
gen rWworkFTPT=.
replace rWworkFTPT=1 if rWjhourswkTOT>1&rWjhourswkTOT<31
replace rWworkFTPT=2 if rWjhourswkTOT>30&rWjhourswkTOT<168
replace rWworkFTPT=0 if rWwork_==0
label define workFTPT2 0 "0.not working" 1 "1.PT < 31" 2 "2.FT > 30"
label values rWworkFTPT workFTPT2
label var rWworkFTPT "FT if >30hr/wk, PT if <31hr/wk"


//accumulated working periods 
gen rWaccWork =.
replace rWaccWork=cond(rWwork_==1&(wave==1|inwFIRST==1),1,0)
by hhidpn: replace rWaccWork = L.rWaccWork+1 if rWwork_==1&(wave!=1|inwFIRST!=1)

//initial age
by hhidpn: egen initialAge=min(cond(inwFIRST==1,rWagey_m_,.))
label var initialAge "=rWagey_m_ when inwFIRST==1"

//accumulated working periods, set to 0 at 50, ..., 10 at 60, ...
gen rWaccWorkfrom50=.
replace rWaccWorkfrom50=cond(rWwork_==1&(wave==1|inwFIRST==1),initialAge-50,0)
by hhidpn: replace rWaccWorkfrom50 = L.rWaccWorkfrom50+1 if rWwork_==1&(wave!=1|inwFIRST!=1)
//initial accumulated work after 50
by hhidpn: egen initialAFT50=min(cond(inwFIRST==1,rWaccWorkfrom50,.))

//accumulated non-working periods 
gen rWaccNonWork =.
replace rWaccNonWork=cond(rWwork_==0&(wave==1|inwFIRST==1),1,0)
by hhidpn: replace rWaccNonWork = L.rWaccNonWork+1 if rWwork_==0&(wave!=1|inwFIRST!=1)



//indicator for probability of leaving bequest >=$10K being 100
gen rWbeq10kBIN=0
replace rWbeq10kBIN=1 if rWbeq10k_==100
label var rWbeq10kBIN "=1 if prob of $10K+ bequest is 100%"
//indicate time when first bequest response observed
by hhidpn (wave), sort: gen byte beq10KFIRST = cond(rWbeq10k_!= . & L.rWbeq10k_==.,1,0)
//indicate first bequest response observed
by hhidpn: egen initialrWbeq10kBIN=min(cond(beq10KFIRST==1,rWbeq10kBIN,.))
label var initialrWbeq10kBIN "=1 if prob of $10K+ bequest is 100% in first wave observed"

//intial spouse
by hhidpn: egen initialSpouse=min(cond(inwFIRST==1,rWmstat_COMBINE,.))
replace initialSpouse=0 if initialSpouse==2|initialSpouse==3|initialSpouse==4
label var initialSpouse "1 if spouse, 0 otherwise"

//initial LFP
by hhidpn: egen initialLFP=min(cond(inwFIRST==1,rWworkFTPT,.))
label values initialLFP workFTPT2

//generate current LFP
gen currentLFP=.
replace currentLFP=rWworkFTPT
label define LFP 0 "0.not working" 1 "1.part time" 2 "2.full time"
label values currentLFP LFP
label var currentLFP "2=FT, 1=PT, 0=not working; equal to rWworkFTPT"




//at ~line 600 in Createhrs9214enahnced.do


save "S:\m1lpj00\HRS public data 1992-2014\hrs9214enhanced.dta", replace


//////////////////////////////////////////////////////////// do on mac
//state in terms of 2015  dollars
gen rWwgihr2015dol=.
replace rWwgihr2015dol=rWwgihr_/.59 if wave==1
replace rWwgihr2015dol=rWwgihr_/.63 if wave==2
replace rWwgihr2015dol=rWwgihr_/.66 if wave==3
replace rWwgihr2015dol=rWwgihr_/.69 if wave==4
replace rWwgihr2015dol=rWwgihr_/.73 if wave==5
replace rWwgihr2015dol=rWwgihr_/.76 if wave==6
replace rWwgihr2015dol=rWwgihr_/.80 if wave==7
replace rWwgihr2015dol=rWwgihr_/.85 if wave==8
replace rWwgihr2015dol=rWwgihr_/.91 if wave==9
replace rWwgihr2015dol=rWwgihr_/.92 if wave==10
replace rWwgihr2015dol=rWwgihr_/.97 if wave==11
replace rWwgihr2015dol=rWwgihr_/1.0 if wave==12


gen rWwgiwk2015dol=.
replace rWwgiwk2015dol=rWwgiwk_/.59 if wave==1
replace rWwgiwk2015dol=rWwgiwk_/.63 if wave==2
replace rWwgiwk2015dol=rWwgiwk_/.66 if wave==3
replace rWwgiwk2015dol=rWwgiwk_/.69 if wave==4
replace rWwgiwk2015dol=rWwgiwk_/.73 if wave==5
replace rWwgiwk2015dol=rWwgiwk_/.76 if wave==6
replace rWwgiwk2015dol=rWwgiwk_/.80 if wave==7
replace rWwgiwk2015dol=rWwgiwk_/.85 if wave==8
replace rWwgiwk2015dol=rWwgiwk_/.91 if wave==9
replace rWwgiwk2015dol=rWwgiwk_/.92 if wave==10
replace rWwgiwk2015dol=rWwgiwk_/.97 if wave==11
replace rWwgiwk2015dol=rWwgiwk_/1.0 if wave==12


gen rWiearn2015dol=.
replace rWiearn2015dol=rWiearn_/.59 if wave==1
replace rWiearn2015dol=rWiearn_/.63 if wave==2
replace rWiearn2015dol=rWiearn_/.66 if wave==3
replace rWiearn2015dol=rWiearn_/.69 if wave==4
replace rWiearn2015dol=rWiearn_/.73 if wave==5
replace rWiearn2015dol=rWiearn_/.76 if wave==6
replace rWiearn2015dol=rWiearn_/.80 if wave==7
replace rWiearn2015dol=rWiearn_/.85 if wave==8
replace rWiearn2015dol=rWiearn_/.91 if wave==9
replace rWiearn2015dol=rWiearn_/.92 if wave==10
replace rWiearn2015dol=rWiearn_/.97 if wave==11
replace rWiearn2015dol=rWiearn_/1.0 if wave==12


gen sWiearn2015dol=.
replace sWiearn2015dol=sWiearn_/.59 if wave==1
replace sWiearn2015dol=sWiearn_/.63 if wave==2
replace sWiearn2015dol=sWiearn_/.66 if wave==3
replace sWiearn2015dol=sWiearn_/.69 if wave==4
replace sWiearn2015dol=sWiearn_/.73 if wave==5
replace sWiearn2015dol=sWiearn_/.76 if wave==6
replace sWiearn2015dol=sWiearn_/.80 if wave==7
replace sWiearn2015dol=sWiearn_/.85 if wave==8
replace sWiearn2015dol=sWiearn_/.91 if wave==9
replace sWiearn2015dol=sWiearn_/.92 if wave==10
replace sWiearn2015dol=sWiearn_/.97 if wave==11
replace sWiearn2015dol=sWiearn_/1.0 if wave==12


gen hWatota2015dol=.
replace hWatota2015dol=hWatota_/.59 if wave==1
replace hWatota2015dol=hWatota_/.63 if wave==2
replace hWatota2015dol=hWatota_/.66 if wave==3
replace hWatota2015dol=hWatota_/.69 if wave==4
replace hWatota2015dol=hWatota_/.73 if wave==5
replace hWatota2015dol=hWatota_/.76 if wave==6
replace hWatota2015dol=hWatota_/.80 if wave==7
replace hWatota2015dol=hWatota_/.85 if wave==8
replace hWatota2015dol=hWatota_/.91 if wave==9
replace hWatota2015dol=hWatota_/.92 if wave==10
replace hWatota2015dol=hWatota_/.97 if wave==11
replace hWatota2015dol=hWatota_/1.0 if wave==12
label var hWatota2015dol "total of all assets--cross wave"


gen hWatotf2015dol=.
replace hWatotf2015dol=hWatotf_/.59 if wave==1
replace hWatotf2015dol=hWatotf_/.63 if wave==2
replace hWatotf2015dol=hWatotf_/.66 if wave==3
replace hWatotf2015dol=hWatotf_/.69 if wave==4
replace hWatotf2015dol=hWatotf_/.73 if wave==5
replace hWatotf2015dol=hWatotf_/.76 if wave==6
replace hWatotf2015dol=hWatotf_/.80 if wave==7
replace hWatotf2015dol=hWatotf_/.85 if wave==8
replace hWatotf2015dol=hWatotf_/.91 if wave==9
replace hWatotf2015dol=hWatotf_/.92 if wave==10
replace hWatotf2015dol=hWatotf_/.97 if wave==11
replace hWatotf2015dol=hWatotf_/1.0 if wave==12
label var hWatotf2015dol "non-housing financial wealth--cross wave"

gen hWatotfc2015dol=.
replace hWatotfc2015dol=hWatotfc_/.59 if wave==1
replace hWatotfc2015dol=hWatotfc_/.63 if wave==2
replace hWatotfc2015dol=hWatotfc_/.66 if wave==3
replace hWatotfc2015dol=hWatotfc_/.69 if wave==4
replace hWatotfc2015dol=hWatotfc_/.73 if wave==5
replace hWatotfc2015dol=hWatotfc_/.76 if wave==6
replace hWatotfc2015dol=hWatotfc_/.80 if wave==7
replace hWatotfc2015dol=hWatotfc_/.85 if wave==8
replace hWatotfc2015dol=hWatotfc_/.91 if wave==9
replace hWatotfc2015dol=hWatotfc_/.92 if wave==10
replace hWatotfc2015dol=hWatotfc_/.97 if wave==11
replace hWatotfc2015dol=hWatotfc_/1.0 if wave==12
label var hWatotfc2015dol "change in non-housing financial wealth--cross wave"

gen hWatotn2015dol=.
replace hWatotn2015dol=hWatotn_/.59 if wave==1
replace hWatotn2015dol=hWatotn_/.63 if wave==2
replace hWatotn2015dol=hWatotn_/.66 if wave==3
replace hWatotn2015dol=hWatotn_/.69 if wave==4
replace hWatotn2015dol=hWatotn_/.73 if wave==5
replace hWatotn2015dol=hWatotn_/.76 if wave==6
replace hWatotn2015dol=hWatotn_/.80 if wave==7
replace hWatotn2015dol=hWatotn_/.85 if wave==8
replace hWatotn2015dol=hWatotn_/.91 if wave==9
replace hWatotn2015dol=hWatotn_/.92 if wave==10
replace hWatotn2015dol=hWatotn_/.97 if wave==11
replace hWatotn2015dol=hWatotn_/1.0 if wave==12
label var hWatotn2015dol "non-housing assets--cross wave"

gen hWatotnc2015dol=.
replace hWatotnc2015dol=hWatotnc_/.59 if wave==1
replace hWatotnc2015dol=hWatotnc_/.63 if wave==2
replace hWatotnc2015dol=hWatotnc_/.66 if wave==3
replace hWatotnc2015dol=hWatotnc_/.69 if wave==4
replace hWatotnc2015dol=hWatotnc_/.73 if wave==5
replace hWatotnc2015dol=hWatotnc_/.76 if wave==6
replace hWatotnc2015dol=hWatotnc_/.80 if wave==7
replace hWatotnc2015dol=hWatotnc_/.85 if wave==8
replace hWatotnc2015dol=hWatotnc_/.91 if wave==9
replace hWatotnc2015dol=hWatotnc_/.92 if wave==10
replace hWatotnc2015dol=hWatotnc_/.97 if wave==11
replace hWatotnc2015dol=hWatotnc_/1.0 if wave==12
label var hWatotnc2015dol "change in non-housing assets--cross wave"

gen hWachck2015dol=.
replace hWachck2015dol=hWachck_/.59 if wave==1
replace hWachck2015dol=hWachck_/.63 if wave==2
replace hWachck2015dol=hWachck_/.66 if wave==3
replace hWachck2015dol=hWachck_/.69 if wave==4
replace hWachck2015dol=hWachck_/.73 if wave==5
replace hWachck2015dol=hWachck_/.76 if wave==6
replace hWachck2015dol=hWachck_/.80 if wave==7
replace hWachck2015dol=hWachck_/.85 if wave==8
replace hWachck2015dol=hWachck_/.91 if wave==9
replace hWachck2015dol=hWachck_/.92 if wave==10
replace hWachck2015dol=hWachck_/.97 if wave==11
replace hWachck2015dol=hWachck_/1.0 if wave==12
label var hWachck2015dol "checking, savings-cross wave"

search carryforward //click to install
bysort hhidpn: carryforward rWrisk_, gen(rWrisk_CF)
// binary risk aversion response
gen riskBIN=.
replace riskBIN=0 if (rWrisk_CF==1|rWrisk_CF==2|rWrisk_CF==3)
replace riskBIN=1 if rWrisk_CF==4
label var riskBIN "=1: most risk averse (rWrisk_=4), =0 less risk averse (rWrisk_=1/2/3) in rWrisk_"


//aproximate savings rate based on...
//...change in checking an savings
//change in checking and savings since last WAVE
gen hWachckCH2015dol=.
by hhidpn, sort: replace hWachckCH2015dol=hWachck2015dol-hWachck2015dol[_n-1]
label var hWachckCH2015dol "Change in checking and savings since last Wave"
gen saverateCheckSavings=.
replace saverateCheckSavings=hWachckCH2015dol/(2*rWiearn2015dol[_n-1]) if rWiearn2015dol[_n-1]>0


//...change in total assets
//change in total assets since last WAVE
gen hWatotaCH2015dol=.
by hhidpn, sort: replace hWatotaCH2015dol=hWatota2015dol-hWatota2015dol[_n-1]
label var hWatotaCH2015dol "Change in total assets since last Wave"
gen saverateTotalAssetsCh=.
replace saverateTotalAssetsCh=hWatotaCH2015dol/(2*rWiearn2015dol[_n-1]) if rWiearn2015dol[_n-1]>0

//...change in total non-housing assets
gen saverateTotalnonHousCh=.
replace saverateTotalnonHousCh=hWatotnc2015dol/(2*rWiearn2015dol[_n-1]) if rWiearn2015dol[_n-1]>0

//ln wages
gen ln_rWiearn2015dol=.
replace ln_rWiearn2015dol=log(rWiearn2015dol)

label var ln_rWiearn2015dol "ln of annual earnings"
gen ln_sWiearn2015dol=.
replace ln_sWiearn2015dol=log(sWiearn2015dol)

label var ln_sWiearn2015dol "ln of annual earnings"


//average earnings when age is 50-60
egen hrWiearn2015AVG5060 = mean(rWiearn2015dol) if rWiearn2015dol>0&rWwork_==1&rWagey_b>=50&rWagey_b<=60, by(hhidpn)
egen rWiearn2015AVG5060 =mean(hrWiearn2015AVG5060 ), by (hhidpn)
drop hrWiearn2015AVG5060
label var rWiearn2015AVG5060 "avg iearn when age 50-60 in 2015dol"


// salary compared to average from 50 to 60
gen rWiearn2015COMP5060=.
replace rWiearn2015COMP5060=rWiearn2015AVG5060 - rWiearn2015dol if rWiearn_!=0&rWwork_==1
label var rWiearn2015COMP5060 "avg iearn when 50-60 minus current if working"


//total imputed out-of-pocket medical expenses in 2015  dollars
gen rWoopmd2015dol=.
replace rWoopmd2015dol=rWoopmd_/.59 if wave==1
replace rWoopmd2015dol=rWoopmd_/.63 if wave==2
replace rWoopmd2015dol=rWoopmd_/.66 if wave==3
replace rWoopmd2015dol=rWoopmd_/.69 if wave==4
replace rWoopmd2015dol=rWoopmd_/.73 if wave==5
replace rWoopmd2015dol=rWoopmd_/.76 if wave==6
replace rWoopmd2015dol=rWoopmd_/.80 if wave==7
replace rWoopmd2015dol=rWoopmd_/.85 if wave==8
replace rWoopmd2015dol=rWoopmd_/.91 if wave==9
replace rWoopmd2015dol=rWoopmd_/.92 if wave==10
replace rWoopmd2015dol=rWoopmd_/.97 if wave==11
replace rWoopmd2015dol=rWoopmd_/1.0 if wave==12

//initial OOP medical expenses
by hhidpn: egen initial_rWoopmd2015dol=min(cond(inwFIRST==1,rWoopmd2015dol,.))
label var initial_rWoopmd2015dol "=rWoopmd2015dol when inwFIRST==1"



gen sWoopmd2015dol=.
replace sWoopmd2015dol=sWoopmd_/.59 if wave==1
replace sWoopmd2015dol=sWoopmd_/.63 if wave==2
replace sWoopmd2015dol=sWoopmd_/.66 if wave==3
replace sWoopmd2015dol=sWoopmd_/.69 if wave==4
replace sWoopmd2015dol=sWoopmd_/.73 if wave==5
replace sWoopmd2015dol=sWoopmd_/.76 if wave==6
replace sWoopmd2015dol=sWoopmd_/.80 if wave==7
replace sWoopmd2015dol=sWoopmd_/.85 if wave==8
replace sWoopmd2015dol=sWoopmd_/.91 if wave==9
replace sWoopmd2015dol=sWoopmd_/.92 if wave==10
replace sWoopmd2015dol=sWoopmd_/.97 if wave==11
replace sWoopmd2015dol=sWoopmd_/1.0 if wave==12

//calculate PIA62 and PIA 65 estimates when working with unrestricted data
gen AIME=.
replace AIME=rWiearn2015AVG5060
gen PIA65est=.
replace PIA65est=AIME*.9 if (AIME>0&AIME<=9132)
replace PIA65est=(9132)*.9+(AIME-9132)*.32 if (AIME>9132&AIME<=55032)
replace PIA65est=(9132)*.9+(45900)*.32+(AIME-45900)*.15 if (AIME>55032&AIME<=106800)
replace PIA65est=(9132)*.9+(45900)*.32+(106800-45900)*.15 if (AIME>106800&AIME!=.)
gen PIA62est=.
replace PIA62est=PIA65est*(.9333^3)

//initial Assets: including housing
by hhidpn: egen initialAssets=min(cond(inwFIRST==1,hWatota2015dol,.))
label var initialAssets "=hWatota2015dol when inwFIRST==1"
//initial Assets: excluding housing
by hhidpn: egen initialnonHAssets=min(cond(inwFIRST==1,hWatotn2015dol,.))
label var initialnonHAssets "=hWatotn2015dol when inwFIRST==1"


//initial earnings
by hhidpn: egen initialAnnEarn=min(cond(inwFIRST==1,rWiearn2015dol,.))
label var initialAnnEarn "=rWiearn2015dol when inwFIRST==1"



//initial health
by hhidpn: egen initialHealth=min(cond(inwFIRST==1,rWshlt_COMB,.))
label var initialHealth "=rWshlt_COMB when inwFIRST==1"

//initial spouse work
by hhidpn: egen initial_sWwork=min(cond(inwFIRST==1,sWwork_,.))
label var initial_sWwork "=sWwork_ when inwFIRST==1"



save "/Users/lindsayjacobs/Desktop/10_31_Reworked Data File.dta", replace







