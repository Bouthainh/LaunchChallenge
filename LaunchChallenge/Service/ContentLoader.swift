import Foundation

struct ContentLoader {

    
    static func load() -> ContentModel? {
        //go and look for json file within this project, if fail stop and print msg
        guard let url = Bundle.main.url(forResource: "GalleryData", withExtension: "json") else {
            print("GalleryData.json not found")
            return nil
        }

        do {
            //fill out the models "loading" from json to models
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ContentModel.self, from: data)
        } catch {
            print("Failed to load: \(error)")
            return nil
        }
    }
}
