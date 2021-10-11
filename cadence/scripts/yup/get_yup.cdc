import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import YUP from "../../contracts/YUP.cdc"

pub struct AccountItem {
  pub let itemID: UInt64
  pub let owner: Address
  pub let influencerID: UInt32
  pub let editionID: UInt32
  pub let serialNumber: UInt32
  pub let url: String


  init(itemID: UInt64, owner: Address, influencerID: UInt32, editionID: UInt32, serialNumber: UInt32, url: String) {
    self.itemID = itemID
    self.editionID = editionID
    self.owner = owner
    self.influencerID = influencerID
    self.serialNumber = serialNumber
    self.url = url
  }
}

pub fun main(address: Address, itemID: UInt64): AccountItem? {
  if let collection = getAccount(address).getCapability<&YUP.Collection{NonFungibleToken.CollectionPublic, YUP.YUPCollectionPublic}>(YUP.CollectionPublicPath).borrow() {
    if let item = collection.borrowYUP(id: itemID) {
      return AccountItem(itemID: itemID, owner: address, influencerID: item.influencerID, editionID: item.editionID,serialNumber: item.serialNumber, url: item.url)
    }
  }

  return nil
}
