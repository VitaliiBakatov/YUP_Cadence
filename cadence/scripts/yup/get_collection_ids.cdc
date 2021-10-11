import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import YUP from "../../contracts/YUP.cdc"

pub fun main(address: Address): [UInt64] {
    let account = getAccount(address)

    let collectionRef = account.getCapability(YUP.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs()
}


f847b840170ec8e4ab02a3604134512942bb971193d1ac84443d73d27a74c03cbd9fe80363f6d62039e83eec1d04825125cb2f10aa16390274b302ec2fd52488454865e502038203e8
