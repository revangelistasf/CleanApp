import Foundation


func makeUrl() -> URL {
    URL(string: "https://any-url.com")!
}

func makeInvalidData() -> Data {
    Data()
}

func makeValidData() -> Data {
    Data("{\"name\": \"Roberto\"}".utf8)
}
