import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import YUP from "../../contracts/YUP.cdc"


transaction {
    prepare(signer: AuthAccount) {
        if signer.borrow<&YUP.Collection>(from: YUP.CollectionStoragePath) == nil {

            let collection <- YUP.createEmptyCollection()

            signer.save(<-collection, to: YUP.CollectionStoragePath)

            signer.link<&YUP.Collection{NonFungibleToken.CollectionPublic, YUP.YUPCollectionPublic}>(YUP.CollectionPublicPath, target: YUP.CollectionStoragePath)
        }
    }
}
