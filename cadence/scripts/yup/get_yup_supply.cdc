import YUP from "./NonFungibleToken.cdc"

pub fun main(): UInt64 {
    return YUP.totalSupply
}
