(ns strung.edit
  "Adds interactive diagram editor functions to a given HTML element.

  Note that this namespace can run in either clojure or clojurescript runtime
  environment.
  "
  (:require             [strung.world :as pop])
  )

(defn ui-events-handler [coeffects event]
  (let [cmd (second event)]
        (case cmd
          :mouseDown (let [x (nth event 2)
                           y (nth event 3)]
                       {:dispatch [:editor :add-agent x y]})
          :mouseUp  {}
          :abort    {}
          )))


(defn editor-events-handler [coeffects event]
  (let [cmd (second event)]
    (case cmd
      :tool (let [tool (keyword (nth event 2))
                  db      (:db coeffects)]
              {:db (assoc db :editor-tool tool)})

      :add-agent (let [x (nth event 2)
                       y (nth event 3)
                       db      (:db coeffects)]
                   {:db (assoc db :world (pop/add-agent (:world db) x y))})
      )))
