#|------------------------------------------------------------*-Scheme-*--|
 | File:    %p%
 |
 |          Copyright (C)1997 Donovan Kolbly <d.kolbly@rscheme.org>
 |          as part of the RScheme project, licensed for free use.
 |          See <http://www.rscheme.org/> for the latest information.
 |
 | File version:     %I%
 | File mod date:    %E% %U%
 | System build:     %b%
 | Owned by module:  repl
 |
 | Purpose:          Rewriter code for binding macros
 `------------------------------------------------------------------------|#

(define (do-rewriter form)
    (let ((bdgs (cadr form))
    	  (test (caddr form))
	  (body (cdddr form))
	  (loop-name (gensym)))
	(let ((vars (map car bdgs))
	      (inits (map cadr bdgs))
	      (incs (map (lambda (x) 
	      		    (if (null? (cddr x))
			        (car x) 
				(caddr x)))
			 bdgs)))
	    (list
		'let
		loop-name 
	        (map list vars inits)
		(list
		    'if
		    (car test)
		    (cons 'begin (cdr test))
		    (list
			'begin
			(cons 'begin body)
			(cons loop-name incs)))))))

(define (let*-rewriter form)
  (let ((bdgs (cadr form)))
    (if (null? bdgs)
	(cons 'begin (cddr form))
	(list
	 'let
	 (list (car bdgs))
	 (cons
	  'let*
	  (cons (cdr bdgs)
		(cddr form)))))))

