import Foundation

// MARK: - ProductDetailListResult
struct ProductDetailResult: Codable {
    let Success: Bool?
    let Message: String?
    let Result: DetailResult?
    let Exception: String?
    let IsOriginFromCheckout: Bool?
}

// MARK: - Result
struct DetailResult: Codable {
    let ProductId: Int?
    let ExternalSystemCode, DisplayName: String?
    let Description: Description?
    let BrandName, ActualPriceText: String?
    let ActualPrice: Int?
    let IsStrikeThroughPriceExist: Bool?
    let StrikeThroughPriceText: String?
    let StrikeThroughPrice: Int?
    let DiscountRateText: String?
    let IsVatIncluded: Bool?
    let VatRate: Int?
    let HasHopiParacik: Bool?
    let IsPreOrder, HasQuantitySelector, IsCosmeticProduct, IsBanned: Bool?
    let IsGiftCard, IsAppWidgetNotShown: Bool?
    let Images: [ResultImage]?
    let Installment: Installment?
    let ContentUrl: ContentUrl?
    let CategoryLink, BrandLink: Link?
    let ShareUrl: String?
    let SizeSystem: String?
    let GtmModel: GtmModel?
    let CategoryId: Int?
    let CategoryName, BreadcrumbCategory, List: String?
    let Seller: Seller?
}

// MARK: - Link
struct Link: Codable {
    let Url: String?
    let DisplayName: String?
}

// MARK: - ContentUrl
struct ContentUrl: Codable {
    let Delivery, Shipment, OneCard, SizeChartUrl: String?
    let ShipmentAndDelivery, PreOwnedStatus: String?
}

// MARK: - Description
struct Description: Codable {
    let ozellikler: String?
    
    enum CodingKeys: String, CodingKey {
        case ozellikler = "Özellikler :"
    }
}

// MARK: - GtmModel
struct GtmModel: Codable {
    let Pseas, Pgen, Pdsct, Pother: String?
    let Pmaingroup, Pproductgroup, Pconsignment: String?
}

// MARK: - ResultImage
struct ResultImage: Codable {
    let DisplayOrder: Int?
    let Images: [ImageImage]?
}

// MARK: - ImageImage
struct ImageImage: Codable {
    let SizeCode: String?
    let ImageUrl: String?
}

// MARK: - Installment
struct Installment: Codable {
    let InstallmentWarningText: String?
    let HasInstallmentWarning: Bool?
    let Url: String?
    let InstallmentCount: Int?
}

// MARK: - Seller
struct Seller: Codable {
    let SellerName, SellerTitle: String?
}
