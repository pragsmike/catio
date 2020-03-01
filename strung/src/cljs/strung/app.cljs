(ns strung.app
  ""
  (:require [cljs.core.async :as a :refer (chan timeout)]
            [reagent.core :as reagent :refer [atom]]
            [re-frame.core :as rf]
            [strowger.event :as se]
            [strung.three :as three]
            [strung.events]
            [strung.subs]
            [strung.edit :as edit]
            [strung.world :as pop])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]) )

;; click on an svg element to start dragging it
;; drag to new location, release

(defn- element-offset-xy [event target]
  (let [rect (.getBoundingClientRect target)]
    [(- (.-clientX event) (.-left rect) (.-clientLeft target))
     (- (.-clientY event) (.-top rect)  (.-clientTop target))]))

(defn js->rf-event [nm jse]
  (vec (concat [:editor-ui nm] (element-offset-xy jse (.-target jse)) )))

(defn add-editor-attrs [m]
  (merge m
         {:on-mouseDown #(rf/dispatch (js->rf-event :mouseDown %))
          :on-mouseUp #(rf/dispatch (js->rf-event :mouseUp %))
          :on-mouseLeave #(rf/dispatch (js->rf-event :abort %))
          })
  )

(defn sim-panel []
  (apply vector (concat [:svg (add-editor-attrs {:width 500 :height 500})]
                        (pop/render-world @(rf/subscribe [:world])))))

(defonce tick-number (atom 0))

(defn button [label event]
  [:input {:type "button" :value label :on-click #(rf/dispatch event)}])


(defn choice []
  [:div
   (button "Pyramids" [:switch-to-view :pyramids] )
   (button "Simulation" [:switch-to-view :sim])
   ])


(defn heading []
  [:div.heading
   [:div.title "Strung"]
   [:a {:href "/figwheel-extra-main/auto-testing"} "tests"]
   [choice]
   ])

(defn selected [e]
  (.log js/console (.-value (aget (.-options e) (.-selectedIndex e))))
  (.-value (aget (.-options e) (.-selectedIndex e))))

(defn control-panel []
  (let [running @(rf/subscribe [:running])
        editor-tool @(rf/subscribe [:editor-tool])]
    [:div
     [button (if running "Stop" "Start") [:sim :start]]
     [button "Reset"  [:sim :reset]]
     [button "Single" [:sim :single]]

     [:span {:style {:margin-left "5em"}}]

     [:span editor-tool]
     [:select {:on-change #(rf/dispatch [:editor :tool (selected (.-target %))])}
      [:option {:value "dot"} "Dot"]
      [:option {:value "rect"} "Rect"]
      ]

     [:p.indicator {:style {:background (if running "green" "pink")}}
      [:span
       (str @tick-number)]
      ]]))

(defn calling-component []
  [:div
   [heading]
   (if (= :pyramids @(rf/subscribe [:current-view]))
     [three/gasket-3d]
     [:div
      [control-panel]
      [sim-panel]])])

(defonce god (atom 0))
(defn init []
  (swap! god inc)
  (rf/dispatch [:sim :reset])
  (go (loop [me @god]
        (<! (timeout 16))
        (when @(rf/subscribe [:running])
          (swap! tick-number inc)
          (rf/dispatch [:sim :single])
          )
        (if (= me @god)
          (recur me))
        ))
  (reagent/render-component [calling-component]
                            (.getElementById js/document "container")))

(init)
