(use bitstring
     srfi-14
     defstruct
     posix)
(define file-name "s1.wav") 
(define f (file-open file-name 
                     (+ open/rdonly open/binary open/nonblock)))
(define bytes 
        (car (file-read f 44)))
(bitmatch bytes
          (((chunk-id 32 bitstring)
            (chunk-size 32 little unsigned)
            (riff-type 32 bitstring)
            (fmt-chunk-id 32 bitstring)
            (fmt-chunk-size 32 little unsigned)
            (fmt-chunk-compression-type 16 little unsigned)
            (check (= fmt-chunk-compression-type 1))
            (fmt-chunk-channels 16 little unsigned)
            (check (= fmt-chunk-channels 1))
            (fmt-chunk-slice-rate 32 little unsigned)
            (fmt-chunk-data-rate 32 little unsigned)
            (fmt-chunk-block-alignment 16 little unsigned)
            (fmt-chunk-sample-depth 16 little unsigned)
            (data-chunk-id 32 bitstring)
            (data-chunk-size 32 little unsigned))
           (begin (print "chunk-id:" (bitstring->string chunk-id))
                  (print "chunk-size:" chunk-size) 
                  (print "riff-type:" (bitstring->string riff-type))
                  (print "fmt-chunk-id:" (bitstring->string fmt-chunk-id))
                  (print "fmt-chunk-size:" fmt-chunk-size)
                  (print "fmt-chunk-compression-type:" fmt-chunk-compression-type)
                  (print "fmt-chunk-channels:" fmt-chunk-channels)
                  (print "fmt-chunk-sample-rate:" fmt-chunk-slice-rate)
                  (print "fmt-chunk-data-rate:" fmt-chunk-data-rate)
                  (print "fmt-chunk-block-alignment:" fmt-chunk-block-alignment)
                  (print "fmt-chunk-sample-depth:" fmt-chunk-sample-depth)
                  (print "data-chunk-id:" (bitstring->string data-chunk-id))
                  (print "data-chunk-size:" data-chunk-size)
                  (print "calculated-playback-length: " (/ data-chunk-size
                                                           fmt-chunk-data-rate) " "
                         "seconds.")))
           (else (print "Incorrectly formatted WAV, or invalid file format detected. Please try a properly formatted single channel PCM WAV.")))
(file-close f)
(exit)
