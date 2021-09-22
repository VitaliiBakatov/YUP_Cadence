import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import YUP from "../../contracts/YUP.cdc"

pub fun main(address: Address): [UInt64] {
    let account = getAccount(address)

    let collectionRef = account.getCapability(YUP.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs()
}
