/*Adding oj234 & oj551 variables from HRS fat files to RAND Longitudinal*/
use "/Users/ryanspaight/Documents/1_PAship/Fat Files/1992.dta"
keep hhidpn oj234 oj551
gen wave = 1
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/1992/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/1994.dta"
keep hhidpn oj234 oj551
gen wave = 2
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/1994/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/1996.dta"
keep hhidpn oj234 oj551
gen wave = 3
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/1996/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/1998.dta"
keep hhidpn oj234 oj551
gen wave = 4
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/1998/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2000.dta"
keep hhidpn oj234 oj551
gen wave = 5
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2000/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2002.dta"
keep hhidpn oj234 oj551
gen wave = 6
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2002/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004.dta"
keep hhidpn oj234 oj551
gen wave = 7
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006.dta"
keep hhidpn oj234 oj551
gen wave = 8
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008.dta"
keep hhidpn oj234 oj551
gen wave = 9
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010.dta"
keep hhidpn oj234 oj551
gen wave = 10
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012.dta"
keep hhidpn oj234 oj551
gen wave = 11
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014.dta"
keep hhidpn oj234 oj551
gen wave = 12
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014/_1.dta"

use "/Users/ryanspaight/Documents/1_PAship/Reworked Data/10:25_Reworked Data File.dta"
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/1992/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/1994/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/1996/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/1998/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2000/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2002/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012/_1.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014/_1.dta", update

/*Adding the RWsatlife variable from HRS fat files to RAND Longitudinal*/
use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004/h04f1b.dta"
keep hhidpn jlb505c jlb503q 
gen wave = 7
rename jlb505c rwsatlife
rename jlb503q rwsatturnout
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006/h06f3a.dta"
keep hhidpn klb003c 
gen wave = 8
rename klb003c rwsatlife
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008/h08f3a.dta"
keep hhidpn llb003c 
gen wave = 9
rename llb003c rwsatlife
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010/hd10f5e.dta"
keep hhidpn mlb003c 
gen wave = 10
rename mlb003c rwsatlife
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012/h12f2a.dta"
keep hhidpn nlb003c 
gen wave = 11
rename nlb003c rwsatlife
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014/h14f2a.dta"
keep hhidpn olb002c 
gen wave = 12
rename olb002c rwsatlife
save "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014/_2.dta"

use "/Users/ryanspaight/Documents/1_PAship/Reworked Data/10:25_Reworked Data File.dta"
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2004/_2.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2006/_2.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2008/_2.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2010/_2.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2012/_2.dta", update
merge 1:1 hhidpn wave using "/Users/ryanspaight/Documents/1_PAship/Fat Files/2014/_2.dta", update
