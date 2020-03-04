(ns codec.ptolemy
  "If you get an error like \"Invalid DTD\" when you parse a MoML file,
  you may have to change the DTD directive at the top of the MoML file
  to have the correct URL -- it must be =https:= not =http:=.

  property can have nested properties, in content.  This is used
  to create groups of properties (eg, Annotations) or attach constraints
  such as height and width to properties named 'text'.

  property has class and name attributes (Java instance).
  It can have a value attribute, or a content vector.

  entity
    name
    class
    property*
  "
  (:require [clojure.xml :as xml]
            [clojure.string :as str]))

(defn keywordize [s]
  (keyword (str/replace s #"[ \t\n]" "_")))

(defn construct-one [acc child]
  (case (first child)
    :property (let [[_ k v] child] (assoc-in acc [:properties k] v))
    acc
    ))

(defn construct [children]
  (reduce construct-one {} children))


(defn valspec->val [attrs]                  ; :name :class :value
  (case (:class attrs)
    "ptolemy.data.expr.SingletonParameter" [(keywordize (:name attrs))
                                            (read-string (:value attrs))]
    "ptolemy.data.expr.Parameter" [(keywordize (:name attrs))
                                   (read-string (:value attrs))]
    "ptolemy.kernel.util.StringAttribute" [(keywordize (:name attrs))
                                           (:value attrs)]

    [(keywordize (:name attrs)) (:value attrs)]
    )
  )

(defn pt-property [moml]
  (let [val (valspec->val (:attrs moml))]
    (if (empty? (:content moml))
      val
      {(keywordize (:name (:attrs moml)))
       (reduce merge
               {  }
               (map pt-property (:content moml)))}))
  )

(def pt-blocks nil)

(defn pt-element [moml]
  (let [attrs (:attrs moml)]
    (case (:tag moml)
      :entity [:entity :attrs attrs
               (pt-blocks (:content moml))
               ]

      :property (pt-property moml)
      moml
      )))

(defn pt-blocks [moml]
  (cond (map? moml) (pt-element moml)
        (seqable? moml)  (map pt-blocks moml)
    ))


(comment
  (def pt (clojure.xml/parse "test/SoundSpectrum.xml")))
