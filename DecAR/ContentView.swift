//
//  ContentView.swift
//  DecAR
//
//  Created by iosdev on 16.11.2022.
//
//

import SwiftUI
import RealityKit
import ARKit
import SceneKit

//Localization variables
let circleLabel = NSLocalizedString("CIRLCLE", comment: "circleLabel")
let menuLabel = NSLocalizedString("MENU", comment: "menuLabel")

struct ContentView : View {
    //State variables for menus
    @State private var showMenu = false
    @State private var showFurMenu = false
    @State private var showInstructions = false
    @State private var showingDetail = false

    //Coredata
    @Environment(\.managedObjectContext) private var viewContext
    @Binding public var currentObject: SelectedFurniture
    
    var body: some View {
        let drag = DragGesture()
         .onEnded {
             if $0.translation.width < -100 {
                withAnimation{
                    self.showMenu = false
                }
             }
         }
        
    return NavigationView {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ARViewContainer(showMenu: self.$showMenu, showFurMenu: self.$showFurMenu, showInstructions: self.$showInstructions, currentObject: self.$currentObject)
                    .disabled(self.showMenu ? true : false)
                    .disabled(self.showInstructions ? true : false)
                    .disabled(self.showFurMenu ? true : false)
                    .edgesIgnoringSafeArea(.all)
                                                                
                    if self.showMenu {
                        Menu()
                        .frame(width: geometry.size.width/2)
                        .transition(.move(edge: .leading))
                    }
                                                                
                    if !self.showMenu && !self.showInstructions && self.showFurMenu {
                        FurnitureMenu(isPresented: .constant(self.showingDetail))
                            .transition(.move(edge: .bottom))
                    }
                                                            
                    if !self.showMenu && !self.showFurMenu && self.showInstructions {
                        Instructions()
                        .offset(x: geometry.size.width/2)
                        .frame(width: geometry.size.width/2)
                        .transition(.move(edge: .trailing))
                    }
                }
                .gesture(drag)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        if !(self.showFurMenu || self.showInstructions) {
                            Button(action: {
                                if !self.showMenu {
                                    withAnimation{
                                        self.showMenu = true
                                    }
                                } else {
                                    withAnimation{
                                        self.showMenu = false
                                    }
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("DetailColor"))
                                .frame(width: 32, height: 32)
                                .accessibilityLabel(menuLabel)
                            }
                        }

                    }

                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        if !(self.showFurMenu || self.showMenu) {
                            Button(action: {
                                if !self.showInstructions {
                                    withAnimation{
                                        self.showInstructions = true
                                    }
                                } else {
                                    withAnimation{
                                        self.showInstructions = false
                                    }
                                }
                            }) {
                                Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("DetailColor"))
                                .frame(width: 32, height: 32)
                                .accessibilityLabel(menuInstructionsText)
                            }
                        }
                        
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        if !(self.showFurMenu || self.showMenu || self.showInstructions) {
                            Button(action: {
                                showingDetail = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("DetailColor"))
                                .frame(width: 58, height: 58)
                                .padding(.bottom, 25)
                                .sheet(isPresented: $showingDetail) {
                                    FurnitureMenu(isPresented: $showingDetail)
                                }
                                .accessibilityLabel(circleLabel)
                            }
                        }
                    }
                }
            }
        }
    }
}

//Adding functions to ARView extension
extension ARView: ARCoachingOverlayViewDelegate {
    /*
     Workaround for holding values inside extension
     */
    struct Holder {
        static var currentModelName: String = "stool"
        static var currentObject: SelectedFurniture = SelectedFurniture("stool")
        static var currentList: Array<SelectedFurniture> = [SelectedFurniture("stool")]
    }
    
    var currentModelName: String {
        get {
            return Holder.currentModelName
        }
        set {
            Holder.currentModelName = newValue
        }
    }
    
    var currentObject: SelectedFurniture {
        get {
            return Holder.currentObject
        }
        set {
            Holder.currentObject = newValue
        }
    }
    
    var currentList: Array<SelectedFurniture> {
        get {
            return Holder.currentList
        }
        set {
            Holder.currentList = newValue
        }
    }
          
    var mapSaveURL: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save url  \(error.localizedDescription)")
        }
    }
    
    /*
     Called opportunistically to verify map data can be loaded
     from filesystem.
     */
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    /*
     Add coaching overlay to ARView, which goal
     is to help user navigate horizontal plane
     */
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.delegate = self
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        
        self.addSubview(coachingOverlay)
    }
    
    func getSavedCurrentObject() -> String {
        let furDetail = UserDefaults.standard.object(forKey: "AppCurrentObject") as? String ?? String()
        return furDetail
    }
    
    //Setup AR config
    func setupConfiguration() {
        self.automaticallyConfigureSession = true
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
                
        if
            ARWorldTrackingConfiguration
                .supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
    
    /*
     Adds long press gesture recognizer to the view, which requires
     two finger press for 0.4 seconds and then fires loadExperience()
     function.
     */
    func enableWorldLoad() {
        let longPressGestRecog = UILongPressGestureRecognizer(target: self, action: #selector(loadExperience(recognizer:)))
        
        longPressGestRecog.numberOfTouchesRequired = 2
        longPressGestRecog.allowableMovement = 50
        longPressGestRecog.numberOfTapsRequired = 0
        longPressGestRecog.minimumPressDuration = 0.4

        self.addGestureRecognizer(longPressGestRecog)
    }
    
    //Function for retrieving saved worldMap
    func loadWorldMap(from url: URL) throws -> ARWorldMap {
        let mapData = try Data(contentsOf: url)
        guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData)
            else { throw ARError(.invalidWorldMap) }
        return worldMap
    }
    
    /*
     Called on enableWorldLoad(). Removes current anchors,
     loads saved worldmap to the view, places saved furniture
     to their previous location and creates a new config to the view.
     */
    @objc func loadExperience(recognizer: UILongPressGestureRecognizer) {
        self.scene.anchors.removeAll()
        
        let worldMap = try? loadWorldMap(from: self.mapSaveURL)
        
        if let data = UserDefaults.standard.object(forKey: "SelectedFurnitureCollection") as? Data {
            
            let selectedFurnitures = try? JSONDecoder().decode([SelectedFurniture].self, from: data)
            
            for anchor in worldMap?.anchors ?? [] {
                
                if (anchor.name != nil) {
                    print(anchor)
                    
                    let anchorEntity = AnchorEntity(world: anchor.transform)
                    
                    for furniture in selectedFurnitures ?? [] {
                        
                        if furniture.id == anchor.name {
                            let currentFurniture = furniture
                            print(currentFurniture)
                            let model = retrieveModel(currentFurniture.modelName)
                            
                            anchorEntity.addChild(model)
                            self.scene.addAnchor(anchorEntity)
                            
                            self.installGestures([.translation, .rotation], for: model)
                            
                            let position = simd_make_float3(anchor.transform.columns.3)
                            
                            placeObject(modelEntity: model, at: position)
                        }
                    }
                    
                }
            }
        }
                
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        config.initialWorldMap = worldMap
        
        
        if
            ARWorldTrackingConfiguration
                .supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
                
        self.debugOptions = [.showFeaturePoints]
        self.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    /*
     Adds long press gesture recognizer, which fires handleLongPress()
     function.
     */
    func enableObjectRemoval() {
        let longPressGestRecog = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        
        longPressGestRecog.allowableMovement = 50
        
        self.addGestureRecognizer(longPressGestRecog)
    }
    
    
    //Adds tap gesture recognizer, which fires handleTap() function.
    func enableObjectAdd() {
        let tapGestRecog = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestRecog)
    }
    
    //Adds new object to the tap's raycast location
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        let results = self.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            
            let object = SelectedFurniture(currentModelName)
            self.currentObject = object
            self.currentList.append(object)
            
            let encoder = JSONEncoder()
            let dataFurniture = try? encoder.encode(currentList)
            UserDefaults.standard.set(dataFurniture, forKey: "SelectedFurnitureCollection")
            
            let model = retrieveModel(currentObject.modelName)

            let arAnchor = ARAnchor(name: currentObject.id, transform: firstResult.worldTransform)
            
            self.session.add(anchor: arAnchor)
                        
            self.installGestures([.translation, .rotation], for: model)
            
            placeObject(modelEntity: model, at: position)
        }
    }
    
    //Enables worldmap saving
    func enableWorldPersistance() {
        let rotationGestRecog = UIRotationGestureRecognizer(target: self, action: #selector(saveWorldMap(recognizer:)))
        self.addGestureRecognizer(rotationGestRecog)
    }
        
    //Saves current worldmap to directory
    @objc func saveWorldMap(recognizer: UIRotationGestureRecognizer) {
        self.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
            else {
                print("can't get current worldmap")
                return
            }
                            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.mapSaveURL, options: [.atomic])
                DispatchQueue.main.async {
                        print("map saved to directory")
                }
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
                
        }
    }
    
    //Called when long press is detected
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
                
        /*
         If entity is found at the pressed location, remove the
         object. Loop list that holds all current objects and remove
         the one with matching id from list. Add new list to
         filesystem without the removed object and remove the old one.
        */
        if let modelEntity = self.entity(at: location) {
            if let anchorEntity = modelEntity.anchor,
                anchorEntity.name == currentObject.modelName {
                anchorEntity.removeFromParent()
                
                for (index, object) in self.currentList.enumerated() {
                    if object.id == currentObject.id {
                        self.currentList.remove(at: index)
                    }
                }
                
                UserDefaults.standard.removeObject(forKey: "SelectedFurnitureCollection")
                
                let encoder = JSONEncoder()
                let dataFurniture = try? encoder.encode(currentList)
                UserDefaults.standard.set(dataFurniture, forKey: "SelectedFurnitureCollection")
            }
        }
    }
    
    /*
     Load entity, generate collision shape and
     return it
    */
    func retrieveModel(_ modelName: String) -> ModelEntity {
        let modelEntity = try! ModelEntity.loadModel(named: modelName)
        
        modelEntity.generateCollisionShapes(recursive: true)
        
        return modelEntity
    }
    
    /*
     Place anchor at location, give it
     a name for removal and add model to it
    */
    func placeObject(modelEntity:ModelEntity, at location:SIMD3<Float>) {
        let anchor = AnchorEntity(world: location)
        let secondAnchor = AnchorEntity(world: location)
        
        anchor.name = currentObject.modelName
        secondAnchor.name = currentObject.id
        
        anchor.addChild(modelEntity)
        
        self.scene.anchors.append(anchor)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var showMenu: Bool
    @Binding var showFurMenu: Bool
    @Binding var showInstructions: Bool
    @Binding var currentObject: SelectedFurniture
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        print("aaaaaa", arView.getSavedCurrentObject())
        
        if arView.getSavedCurrentObject().isEmpty {
            arView.currentModelName = "stool"
        } else {
            arView.currentModelName = arView.getSavedCurrentObject()
        }
        
        arView.setupConfiguration()
        
        arView.addCoaching()
        
        arView.enableObjectAdd()

        arView.enableObjectRemoval()
      
        arView.enableWorldPersistance()
        
        arView.enableWorldLoad()
        
        return arView

    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if uiView.getSavedCurrentObject().isEmpty {
            uiView.currentModelName = "stool"
        } else {
            uiView.currentModelName = uiView.getSavedCurrentObject()
        }
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(currentObject: .constant(SelectedFurniture("stool")))
    }
}
#endif
