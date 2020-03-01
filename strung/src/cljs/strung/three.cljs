(ns strung.three
  (:require [reagent.core :as reagent :refer [atom]]
            ))

(defn create-renderer [element]
  (doto (js/THREE.WebGLRenderer. #js {:canvas element :antialias true})
    (.setPixelRatio js/window.devicePixelRatio)))

(defn three-canvas [attributes camera scene tick]
  (let [requested-animation (atom nil)]
    (reagent/create-class
     {:display-name "three-canvas"
      :reagent-render
      (fn three-canvas-render []
        [:canvas attributes])
      :component-did-mount
      (fn three-canvas-did-mount [this]
        (let [e (reagent/dom-node this)
              r (create-renderer e)]
          ((fn animate []
             (tick)
             (.render r scene camera)
             (reset! requested-animation (js/window.requestAnimationFrame animate))))))
      :component-will-unmount
      (fn [this]
        (js/window.cancelAnimationFrame @requested-animation))})))

(defn create-scene []
  (doto (js/THREE.Scene.)
    (.add (js/THREE.AmbientLight. 0x888888))
    (.add (doto (js/THREE.DirectionalLight. 0xffff88 0.5)
            (-> (.-position) (.set -600 300 600))))
    (.add (js/THREE.AxisHelper. 50))))

(defn mesh [geometry color]
  (js/THREE.SceneUtils.createMultiMaterialObject.
   geometry
   #js [(js/THREE.MeshBasicMaterial. #js {:color color :wireframe true})
        (js/THREE.MeshLambertMaterial. #js {:color color})]))

(defn fly-around-z-axis [camera scene]
  (let [t (* (js/Date.now) 0.0002)]
    (doto camera
      (-> (.-position) (.set (* 100 (js/Math.cos t)) (* 100 (js/Math.sin t)) 100))
      (.lookAt (.-position scene)))))

(defn v3 [x y z]
  (js/THREE.Vector3. x y z))

(defn lambda-3d []
  (let [camera (js/THREE.PerspectiveCamera. 45 1 1 2000)
        curve (js/THREE.CubicBezierCurve3.
               (v3 -30 -30 10)
               (v3 0 -30 10)
               (v3 0 30 10)
               (v3 30 30 10))
        path-geometry (js/THREE.TubeGeometry. curve 20 4 8 false)
        scene (doto (create-scene)
                (.add
                 (doto (mesh (js/THREE.CylinderGeometry. 40 40 5 24) "green")
                   (-> (.-rotation) (.set (/ js/Math.PI 2) 0 0))))
                (.add
                 (doto (mesh (js/THREE.CylinderGeometry. 20 20 10 24) "blue")
                   (-> (.-rotation) (.set (/ js/Math.PI 2) 0 0))))
                (.add (mesh path-geometry "white")))
        tick (fn []
               (fly-around-z-axis camera scene))]
    [three-canvas {:width 150 :height 150} camera scene tick]))


(def pyramid-points
  [[-0.5 -0.5 0 "#63B132"] [-0.5 0.5 0 "#5881D8"] [0.5 0.5 0 "#90B4FE"] [0.5 -0.5 0 "#91DC47"] [0 0 1 "white"]])

(defn add-pyramid [scene x y z size color]
  (.add scene
        (doto
          (let [g (js/THREE.Geometry.)]
            (set! (.-vertices g)
                  (clj->js (for [[i j k] pyramid-points]
                             (v3 i j k))))
            (set! (.-faces g)
                  (clj->js (for [[i j k] [[0 1 2] [0 2 3] [1 0 4] [2 1 4] [3 2 4] [0 3 4]]]
                             (js/THREE.Face3. i j k))))
            (mesh g color))
          (-> (.-position) (.set x y z))
          (-> (.-scale) (.set size size size)))))

(defn add-pyramids [scene x y z size color]
  (if (< size 4)
    (add-pyramid scene x y z (* size 1.75) color)
    (doseq [[i j k color] pyramid-points]
      (add-pyramids scene
                    (+ x (* i size))
                    (+ y (* j size))
                    (+ z (* k size))
                    (/ size 2)
                    color))))

(defn gasket-3d []
  (let [camera (js/THREE.PerspectiveCamera. 45 1 1 2000)
        scene (doto (create-scene)
                (add-pyramids 0 0 0 32 "white"))
        tick (fn [] (fly-around-z-axis camera scene))]
    [three-canvas {:width 640 :height 640} camera scene tick]))

