enum AppCategories {
    static let all: [DiscountCategory] = [
        DiscountCategory(id: "entertainment", name: "გართობა", icon: "gamecontroller.fill"),
        DiscountCategory(id: "food",          name: "საკვები",  icon: "fork.knife"),
        DiscountCategory(id: "retail",        name: "შოპინგი",  icon: "bag.fill"),
    ]

    static let allWithAll: [DiscountCategory] = [
        DiscountCategory(id: "all", name: "ყველა", icon: "square.grid.2x2.fill"),
    ] + all

    static func georgianName(for id: String) -> String {
        all.first { $0.id == id }?.name ?? id
    }
}
