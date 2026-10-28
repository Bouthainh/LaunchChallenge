import Foundation

enum ItemState { case locked, new, collected }

/// مؤقت، يُستبدل بـ RewardModel لما يجهز. الـ id لازم يطابق rewardStickerId
struct BagItem: Identifiable, Hashable {
    let id: String
    let name: String
    let region: Region
    let imageName: String
}

extension BagItem {
    static let sample: [BagItem] = [
        .init(id: "west_nested_squares", name: "المربعات المتداخلة", region: .west,    imageName: "western_nested_squares"),
        .init(id: "central_sun",         name: "الشمس",              region: .central, imageName: "southern_sun"),
        .init(id: "east_triangle_palm",  name: "نخلة المثلثات",      region: .east,    imageName: "eastern_triangle_palm"),
        .init(id: "north_wavy_diamond",  name: "المعيّن المتموج",    region: .north,   imageName: "northern_wavy_diamond"),
        .init(id: "south_qatt",          name: "القط",               region: .south,   imageName: "central_najdi_triangles")
    ]
}


