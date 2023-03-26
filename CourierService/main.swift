import ArgumentParser
import CourierService_Library

struct Menu: ParsableCommand {
    @Argument() var highValue: Int

    func run() {
        print("meow")
        print(Int.random(in: 1...highValue))
    }
}

Menu.main()
