(defun c:khz()
	
	(setq mz(list (cons 6 0.222)(cons 8 0.395)(cons 10 0.617)(cons 12 0.888)(cons 14 1.21)(cons 16 1.58)(cons 18 2.00)
						(cons 20 2.47)(cons 22 2.98)(cons 25 3.85)(cons 28 4.83)(cons 32 6.31)(cons 36 7.99)(cons 40 9.87)(cons 50 15.42)
					))
	(setq Prestressmz(list (cons 6 0.222)(cons 8 0.395)(cons 10 0.617)(cons 12 0.888)(cons 14 1.21)(cons 16 1.58)(cons 18 2.11)
										 (cons 20 2.47)(cons 22 2.98)(cons 25 4.10)(cons 28 4.83)(cons 32 6.65)(cons 36 7.99)(cons 40 10.34)(cons 50 16.28)
									 ))
	(mlayer "khz-1" 1 "continuous")
	(mlayer "khz-2" 2 "continuous")
	(mlayer "khz-3" 3 "continuous")
	(mlayer "khz-4" 4 "continuous")
	(mlayer "khz-7" 7 "continuous");text
	(setq kn 0.025);考虑到钢筋直径，mm为单位
	(setq b (* 2000 kn) h (* 3000 kn));抗滑桩bxh
	(setq bc (* kn 50) hc (* kn 70) zc (* kn 50));抗滑桩三个方向保护层厚度
	
	;N1筋为纵向构造钢筋，2000为根数码，2001为钢筋直径码
	(setq radm (* kn 32)  hh1 (* kn 180) hh2 (* kn 180))
	(setq zhujin(list (list "112" "112" "112" "112" "112" "112" "112" "112" "112" "112" "112" "112")
								(list "32" "323" "322" "323" "322" "323" "322" "32" "322" "322" "322")
							  (list "33" "33" "33" "33" "33" "33")
							))
	(setq yajin(list "111" "11" "111" "11" "11" "111" "111" "111") ryajin 32)
	(setq gouzaojin 6 rgzjin 28);两边各   个
	(setq z1 (car zhujin)
		z2(cadr zhujin)
		z3(caddr zhujin)
	)
	(setvar0)
	(setq pt(getpoint "enter the point:"))
	(terpri)
	;(AddLine (ptxy pt (- (* b 0.3)) (- (* h 0.1)))
	;	(ptxy pt (- b bc (/ radm 2) (/ (+ (* h 0.1) hc (/ radm 2)) (sqrt 3))) (- (* h 0.1))))
	(AddLine (ptxy pt (- (* b 0.3)) (- (* h 0.05)))
		(ptxy pt (- b bc radm) (- (* h 0.05))))
	(setq line1(vlax-ename->vla-object (entlast)))	
	(AddLine (ptxy pt (- (* b 0.3))  (* hc 0.5)) 
		(ptxy pt (- b bc radm) (* hc 0.5)))
	(setq line2(vlax-ename->vla-object (entlast)))
	
	(if (/= 0 hh2)
		(progn
			(AddLine (ptxy pt (- (* b 0.3)) (+ hh1  hh2 (* hc 2))) (ptxy pt (- b bc radm) (+ hh1 hh2 (* hc 2))))
			(setq line3(vlax-ename->vla-object (entlast)))
			
		)
	)
	
	(jiemian zhujin pt b h bc hc hh1 hh2 kn radm yajin gouzaojin)
	;(command "RECTANG" "W" 0 pt (ptxy pt b h))
	;(command "RECTANG" "W" (* kn 10) (ptxy pt bc hc) (ptxy pt (- b bc) (- h hc)))
	;(setq z3start(ptxy pt bc hc) z3end(ptxy z3start bn 0))
	;(setq z2start(ptxy z3start 0 hh1) z2end(ptxy z3end 0 hh1))
	;(setq z1start(ptxy z2start 0 hh2) z1end(ptxy z2end 0 hh2))
	;(donutspts z1 z1start z1end)
	;(donutspts z2 z2start z2end)
	;(donutspts z3 z3start z3end)
	;
	;(setvar "CLAYER" "khz-4")
	;(setq z2p1(ptxy z2start (- (* 12 kn)) (* 20 kn))
	;	z2p2(ptxy z2start (- (* 12 kn)) 0)
	;	z2p3(ptxy z2end (* 12 kn) 0)
	;	z2p4(ptxy z2end (* 12 kn) (* 20 kn))
	;)
	;(command "PLINE"  z2p1 "W" (* kn 10) (* kn 10) z2p2 z2p3 z2p4 "")
	;(setq z1p1(ptxy z1start (- (* 12 kn)) (* 20 kn))
	;	z1p2(ptxy z1start (- (* 12 kn)) 0)
	;	z1p3(ptxy z1end (* 12 kn) 0)
	;	z1p4(ptxy z1end (* 12 kn) (* 20 kn))
	;)
	;(command "PLINE"  z1p1 "W" (* kn 10) (* kn 10) z1p2 z1p3 z1p4 "")
	
	(resetvar0)
)

(defun jiemian(zhujin pt b h bc hc hh1 hh2 kn radm yajin gouzaojin)
	
	(setq z1(car zhujin))
	(if(not(null (cadr zhujin))) (setq z2(cadr zhujin)))
	(if(not(null (caddr zhujin)))(setq z3(caddr zhujin)))
	(setq bn(- b bc bc) hn(- h hc hc))
	;(setvar0)
	(command "RECTANG" "W" 0 pt (ptxy pt b h))
	;(command "RECTANG" "W" (* kn 10) (ptxy pt bc hc) (ptxy pt (- b bc) (- h hc)))
	(setq slen(length z1))
	(setq dts2(/ (- bn (* 2 slen radm)) (- slen 1)))
	(setq nn1(fix (* 0.75 slen)) ll1(+ (* 2 nn1 radm)(* dts2 (1- nn1))))
	
	;(setq z3start(ptxy pt bc hc) z3end(ptxy z3start bn 0))
	;(setq z2start(ptxy z3start 0 hh1) z2end(ptxy z3end 0 hh1))
	;(setq z1start(ptxy z2start 0 hh2) z1end(ptxy z2end 0 hh2))
	;(donutspts z1 z1start z1end)
	;(donutspts z2 z2start z2end)
	;(donutspts z3 z3start z3end)
	
	(setq z1start(ptxy pt bc hc) z1end(ptxy z1start bn 0))
	(command "RECTANG" "W" (* kn 10) z1start (ptxy z1start ll1 hn))
	(command "COPY" (entlast) "" (ptxy z1start ll1 0) z1end "")
	(donutspts z1 z1start z1end radm)
	
	(setq gzstart1 z1start gzend1 z1end)
	(if (/= hh1 0)
		(progn
			(setq z2start(ptxy z1start 0 hh1) z2end(ptxy z1end 0 hh1))
			(donutspts z2 z2start z2end radm)
			(setvar "CLAYER" "khz-4")
			(setq z2p1(ptxy z2start (- (* 12 kn)) (* 20 kn))
				z2p2(ptxy z2start (- (* 12 kn)) 0)
				z2p3(ptxy z2end (* 12 kn) 0)
				z2p4(ptxy z2end (* 12 kn) (* 20 kn))
			)
			(command "PLINE"  z2p1 "W" (* kn 10) (* kn 10) z2p2 z2p3 z2p4 "")
			(setq gzstart1 z2start gzend1 z2end)
		)		
	)
	(if (/= hh2 0)
		(progn
			(setq z3start(ptxy z2start 0 hh2) z3end(ptxy z2end 0 hh2))
			(donutspts z3 z3start z3end radm)
			(setvar "CLAYER" "khz-4")
			(setq z3p1(ptxy z3start (- (* 12 kn)) (* 20 kn))
				z3p2(ptxy z3start (- (* 12 kn)) 0)
				z3p3(ptxy z3end (* 12 kn) 0)
				z3p4(ptxy z3end (* 12 kn) (* 20 kn))
			)
			(command "PLINE"  z3p1 "W" (* kn 10) (* kn 10) z3p2 z3p3 z3p4 "")
			(setq gzstart1 z3start gzend1 z3end)
		)		
	)
	
	(setq ptyastart(ptxy z1start 0 (- hn radm))
		ptyaend(ptxy z1end 0 (- hn radm))
	)
	(donutspts2 yajin ptyastart ptyaend radm)
	(setq dd(- (distance gzstart1 ptyastart) radm) ss(/ dd (+ gouzaojin 1)) i 1)
	(repeat gouzaojin
		(setq gouzaop1(ptxy gzstart1 (/ (* kn rgzjin) 2) (* i ss)) gouzaop2(ptxy gzend1 (- (/ (* kn rgzjin) 2)) (* i ss)))
		(addnut gouzaop1 (* kn rgzjin))
		(addnut gouzaop2 (* kn rgzjin))
		(setq i(1+ i))
	)
	
	;(resetvar0)
)
(defun addnut(pt r)
	(command "DONUT" 0  r pt "")
)
(defun adddirline(pt ang dist)
	(AddLine pt (polar pt ang dist))
)
(defun setlay(str)
	(cond ((= str "1")(setvar "CLAYER" "khz-1"))
		((= str "2")(setvar "CLAYER" "khz-2"))
		((= str "3")(setvar "CLAYER" "khz-3"))
		((= str "4")(setvar "CLAYER" "khz-4"))
	)
)
(defun dodirlinepts(ptlists ptstart ptend hc)
	(setq n (length ptlists))
)
(defun khz:createhelpline1(ptlist pt kn)
	(setq n(length ptlist) i 0)
	(repeat n 
		(setq il(nth i ptlist))
		(setq listi(vl-string->list il))
	)
)
(defun khz:nlists(zhujin pt )
	(setq i 0 n(length plists))
	
)
(defun donutspts(plists ptstart ptend r)
	(setq n(length plists) i 0 ntotal 0 nup 0 ndown 0)
	(repeat n
		(setq il(nth i plists))
		(setq ilen(strlen il))
		(if(> ilen 2)(setq nup(1+ nup) iilen 2)(setq iilen ilen))
		(setq ndown(+ ndown iilen))
		(setq i(1+ i))
	)
	(setq ntotal(+ nup ndown) dts(/ (- bn (* ndown r)) (- n 1)))
	(setq i 0)
	(repeat n
		(setq il(nth i plists) listi(vl-string->list il))
		(setq ilen(strlen il))
		(cond ((= 1 ilen) (progn
												(setq p1(ptxy ptstart (/ r 2) (/ radm 2)))
												(setlay il)
												(addnut p1 r)
												(cond 
													((= 49 (car listi)) (progn
																								(setq ptm1(vlax-curve-getClosestPointTo line1))
																								(adddirline p1 (/ (* 4 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							))
													((= 50 (car listi)) (progn
																								(setq ptm1(vlax-curve-getClosestPointTo line2))
																								(adddirline p1 (/ (* 17 pi) 12) (/ (distance ptm1 p1) (cos (/ pi 12))))
																							))
													((= 51 (car listi)) (progn
																								(setq ptm1(vlax-curve-getClosestPointTo line3))
																								(adddirline p1 (/ (* 2 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							))
												)
												;(adddirline p1 (/ (* pi 4) 3) (* 2 hc))
												(setq id 1)
											))
			((= 2 ilen) (progn
										(setq p1(ptxy ptstart (/ r 2) (/ r 2)))
										(setlay (substr il 1 1))
										(addnut p1 r)
										(cond 
											((= "1" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line1 p1))
																								 (adddirline p1 (/ (* 4 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							 ))
											((= "2" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line2 p1))
																								 (adddirline p1 (/ (* 17 pi) 12) (/ (distance ptm1 p1) (cos (/ pi 12))))
																							 ))
											((= "3" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line3 p1))
																								 (adddirline p1 (/ (* 2 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							 ))
										)
										;(adddirline p1 (/ (* pi 4) 3) (* 2 hc) )
										(setq p2(ptxy p1 r 0))
										(setlay(substr il 2 1))
										(addnut p2 r)
										(cond 
											((= "1" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line1 p2))
																								 (adddirline p2 (/ (* 4 pi) 3) (* (distance ptm1 p2) (/ 2 (sqrt 3))))
																							 ))
											((= "2" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line2 p2))
																								 (adddirline p2 (/ (* 17 pi) 12) (/ (distance ptm1 p2) (cos (/ pi 12))))
																							 ))
											((= "3" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line3 p2))
																								 (adddirline p2 (/ (* 2 pi) 3) (* (distance ptm1 p2) (/ 2 (sqrt 3))))
																							 ))
										)
										;(adddirline p2 (/ (* pi 4) 3) (* 2 hc) )
										(setq id 2)
									))
			((= 3 ilen) (progn
										(setq p1(ptxy ptstart (/ r 2) (/ r 2)))
										(setlay(substr il 1 1))
										(addnut p1 r)
										(cond 
											((= "1" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line1 p1))
																								 (adddirline p1 (/ (* 4 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							 ))
											((= "2" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line2 p1))
																								 (adddirline p1 (/ (* 17 pi) 12) (/ (distance ptm1 p1) (cos (/ pi 12))))
																							 ))
											((= "3" (substr il 1 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line3 p1))
																								 (adddirline p1 (/ (* 2 pi) 3) (* (distance ptm1 p1) (/ 2 (sqrt 3))))
																							 ))
										)
										;(adddirline p1 (/ (* pi 4) 3) (* 2 hc) )
										(setq p2(ptxy p1 r 0))
										(setlay(substr il 2 1))
										(addnut p2 r)
										(cond 
											((= "1" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line1 p2))
																								 (adddirline p2 (/ (* 4 pi) 3) (* (distance ptm1 p2) (/ 2 (sqrt 3))))
																							 ))
											((= "2" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line2 p2))
																								 (adddirline p2 (/ (* 17 pi) 12) (/ (distance ptm1 p2) (cos (/ pi 12))))
																							 ))
											((= "3" (substr il 2 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line3 p2))
																								 (adddirline p2 (/ (* 2 pi) 3) (* (distance ptm1 p2) (/ 2 (sqrt 3))))
																							 ))
										)
										;(adddirline p2 (/ (* pi 4) 3) (* 2 hc) )
										(setq p3(polar p1 (/ pi 3) r))
										(setlay(substr il 3 1))
										(addnut p3 r)
										(cond 
											((= "1" (substr il 3 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line1 p3))
																								 (adddirline p3 (/ (* 4 pi) 3) (* (distance ptm1 p3) (/ 2 (sqrt 3))))
																							 ))
											((= "2" (substr il 3 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line2 p3))
																								 (adddirline p3 (/ (* 17 pi) 12) (/ (distance ptm1 p3) (cos (/ pi 12))))
																							 ))
											((= "3" (substr il 3 1)) (progn
																								 (setq ptm1(vlax-curve-getClosestPointTo line3 p3))
																								 (adddirline p3 (/ (* 2 pi) 3) (* (distance ptm1 p3) (/ 2 (sqrt 3))))
																							 ))
										)
										;(adddirline p3 (/ (* pi 4) 3) (* 2 hc) )
										(setq id 2)
									))
			
		)
		(setq ptstart(ptxy ptstart (+ dts (* id r)) 0))
		(setq i(1+ i))
	)
	
)
(defun donutspts2(plists ptstart ptend r)
	(setq n(length plists) i 0 ntotal 0 nup 0 ndown 0)
	(repeat n
		(setq il(nth i plists))
		(setq ilen(strlen il))
		(if(> ilen 2)(setq nup(1+ nup) iilen 2)(setq iilen ilen))
		(setq ndown(+ ndown iilen))
		(setq i(1+ i))
	)
	(setq ntotal(+ nup ndown) dts(/ (- bn (* ndown r)) (- n 1)))
	(setq i 0)
	(repeat n
		(setq il(nth i plists))
		(setq ilen(strlen il))
		(cond ((= 1 ilen) (progn
												(setq p1(ptxy ptstart (/ r 2) (/ r 2)))
												(setlay il)
												(addnut p1 r)
												(setq id 1)
											))
			((= 2 ilen) (progn
										(setq p1(ptxy ptstart (/ r 2) (/ r 2)))
										(setlay (substr il 1 1))
										(addnut p1 r)
										(setq p2(ptxy p1 r 0))
										(setlay(substr il 2 1))
										(addnut p2 r)
										(setq id 2)
									))
			((= 3 ilen) (progn
										(setq p1(ptxy ptstart (/ r 2) (/ r 2)))
										(setlay(substr il 1 1))
										(addnut p1 r)
										(setq p2(ptxy p1 r 0))
										(setlay(substr il 2 1))
										(addnut p2 r)
										(setq p3(polar p1 (- (/ pi 3)) r))
										(setlay(substr il 3 1))
										(addnut p3 r)
										(setq id 2)
									))
			
		)
		(setq ptstart(ptxy ptstart (+ dts (* id r)) 0))
		(setq i(1+ i))
	)
	
)