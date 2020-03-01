(ns codec.ptolemy-test
  (:require [clojure.test :refer :all]
            [codec.ptolemy :refer :all]) )

(defn sample-pt [name]
  (clojure.xml/parse "test/SoundSpectrum.xml"))

(def valspec-1 {:value "true"
                :class "ptolemy.data.expr.SingletonParameter"
                :name "_hideName"})
(def valspec-2 {:class "ptolemy.actor.gui.style.TextStyle"
                :name "_style"})
(def valspec-3 {:value "20"
                :class "ptolemy.data.expr.Parameter"
                :name "height"})
(def valspec-4 {:value "The name of the riddle"
                :class "ptolemy.kernel.util.StringAttribute"
                :name "text"})

(deftest test-valspec->val
  (is (= [:_hideName true] (valspec->val valspec-1)))
  (is (= [:_style nil] (valspec->val valspec-2)))
  (is (= [:height 20] (valspec->val valspec-3)))
  (is (= [:text "The name of the riddle"] (valspec->val valspec-4)))
  )

(def prop-2 {:tag :property
             :attrs valspec-1
             :content nil})

(deftest test-prop-2
  (is (= [:_hideName true] (pt-property prop-2))))

(def prop-25 {:tag :property
               :attrs
               {:class "ptolemy.actor.gui.style.TextStyle" :name "_style"}
               :content
               [{:tag :property
                 :attrs
                 {:value "20"
                  :class "ptolemy.data.expr.Parameter"
                  :name "height"}
                 :content nil}
                {:tag :property
                 :attrs
                 {:value "80"
                  :class "ptolemy.data.expr.Parameter"
                  :name "width"}
                 :content nil}]})

(def prop-27 {:tag :property
              :attrs {:value "20"
                      :class "ptolemy.data.expr.Parameter"
                      :name "height"}
              :content nil})

(deftest test-prop-25
  (is (= 0 (count (:content prop-27))))
  (is (= [:height 20] (pt-property prop-27)))
  (is (= [[:height 20][:width 80]] (map pt-property (:content prop-25))))
  (is (= {:_style {:width 80 :height 20}} (pt-property prop-25)))
  )

(def prop-3 {:tag :property
             :attrs
             {:value
              "The model of computation is\nsynchronous dataflow (SDF)."
              :class "ptolemy.kernel.util.StringAttribute"
              :name "text"}
             :content
             [{:tag :property
               :attrs
               {:class "ptolemy.actor.gui.style.TextStyle" :name "_style"}
               :content
               [{:tag :property
                 :attrs
                 {:value "20"
                  :class "ptolemy.data.expr.Parameter"
                  :name "height"}
                 :content nil}
                {:tag :property
                 :attrs
                 {:value "80"
                  :class "ptolemy.data.expr.Parameter"
                  :name "width"}
                 :content nil}]}]})

(deftest test-prop-3
  (is (= [:text "The model of computation is\nsynchronous dataflow (SDF)."
          :_style { :height 20 :width 20 }
          ]
         (pt-property prop-3)))
  )



(def expected-4
  {:name "property"
   :content {:name "text"
           :class "ptolemy.kernel.util.StringAttribute"
           :value "The model of computation is\nsynchronous dataflow (SDF)."
           :content [
                     {:class "ptolemy.actor.gui.style.TextStyle"
                      :name "_style"
                      :content [{:value "20"
                                 :class "ptolemy.data.expr.Parameter"
                                 :name "height"}
                                {:value "80"
                                 :class "ptolemy.data.expr.Parameter"
                                 :name "width"}
                                ]}]}})




(deftest test-construct
  (is (= {:properties {:a "1" :b "2"}} (construct [[:property :a "1"] [:property :b "2"]
                                     [:something-else]])))
  )

(deftest test-ptolemy
  (let [pt (sample-pt "SoundSpectrum")]
    #_(is (= nil (pt-blocks pt)))
    ))








