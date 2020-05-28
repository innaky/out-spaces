(defsystem "out-spaces"
  :version "0.1.0"
  :author "Innaky"
  :license "GPLv3"
  :depends-on ("cl-fad")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "out-spaces/tests"))))

(defsystem "out-spaces/tests"
  :author "Innaky"
  :license "GPLv3"
  :depends-on ("out-spaces"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for out-spaces"
  :perform (test-op (op c) (symbol-call :rove :run c)))
