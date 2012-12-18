
(define (pserver-authentication-handshake (self <pserver-connection>))
  (let* ((p (input-port (socket self)))
         (o (output-port (socket self)))
         (greeting (read-line p)))
    (dm 601 "greeting ~s" greeting)
    (let ((cvsroot (read-line p)))
      (dm 602 "cvs root ~s" cvsroot)
      (let ((username (read-line p)))
        (dm 603 "user ~s" username)
        (let ((password (read-line p)))
          (dm 604 "password ~s" password)
          (let ((eogreeting (read-line p)))
            (dm 605 "end greeting ~s" eogreeting)
            (let ((a (authenticate (realm self)
                                   username
                                   (cvs-pass-unscramble password))))
              (if a
                  (begin
                    (note 502 "authenticated as ~s" a)
                    (format o "I LOVE YOU\n")
                    (flush-output-port o)
                    (if (string=? greeting "BEGIN AUTH REQUEST")
                        a
                        #f))
                  (begin
                    (wm 503 "rejected authentication from ~s" username)
                    (format o "I HATE YOU\n")
                    (flush-output-port o)
                    #f)))))))))


(define (cvs-pass-unscramble str)
  (case (string-ref str 0)
    ((#\A)
     (list->string
      (map (lambda (ch)
             (or (table-lookup *cvs-unscramble* ch) #\?))
           (string->list (substring str 1)))))
    (else
     (em 504 "Unknown password encoding ~s" str))))

         

(define *cvs-scramble-encoding*
  '((#\! 120)
    (#\"  53)
    (#\% 109)
    (#\&  72)
    (#\' 108)
    (#\(  70)
    (#\)  64)
    (#\*  76)
    (#\+  67)
    (#\, 116)
    (#\-  74)
    (#\.  68)
    (#\/  87)
    (#\0 111)
    (#\1  52)
    (#\2  75)
    (#\3 119)
    (#\4  49)
    (#\5  34)
    (#\6  82)
    (#\7  81)
    (#\8  95)
    (#\9  65)
    (#\: 112)
    (#\;  86)
    (#\< 118)
    (#\= 110)
    (#\> 122)
    (#\? 105)
    (#\A  57)
    (#\B  83)
    (#\C  43)
    (#\D  46)
    (#\E 102)
    (#\F  40)
    (#\G  89)
    (#\H  38)
    (#\I 103)
    (#\J  45)
    (#\K  50)
    (#\L  42)
    (#\M 123)
    (#\N  91)
    (#\O  35)
    (#\P 125)
    (#\Q  55)
    (#\R  54)
    (#\S  66)
    (#\T 124)
    (#\U 126)
    (#\V  59)
    (#\W  47)
    (#\X  92)
    (#\Y  71)
    (#\Z 115)
    (#\_  56)
    (#\a 121)
    (#\b 117)
    (#\c 104)
    (#\d 101)
    (#\e 100)
    (#\f  69)
    (#\g  73)
    (#\h  99)
    (#\i  63)
    (#\j  94)
    (#\k  93)
    (#\l  39)
    (#\m  37)
    (#\n  61)
    (#\o  48)
    (#\p  58)
    (#\q 113)
    (#\r  32)
    (#\s  90)
    (#\t  44)
    (#\u  98)
    (#\v  60)
    (#\w  51)
    (#\x  33)
    (#\y  97)
    (#\z  62)))

(define *cvs-unscramble*
  (let ((t (make-char-table)))
    (for-each (lambda (enc)
                (table-insert! t (integer->char (cadr enc)) (car enc)))
              *cvs-scramble-encoding*)
    t))