# Kiki Courier-Service-Everest, by [Shawn Ngo Yen Sern](https://www.linkedin.com/in/ngo-yensern/?originalSubdomain=my)

## Installation

1. Clone the repo 
2. Open `CourierService.xcodeproj` using `Xcode`, with minimum version of `macOS 10.13` and `Xcode version 13`
3. You should be on `master` branch
4. Double click `CourierService` on the right panel, select `CourierService` target and go to `Signing & Capabilities` tab, change the `Team` to your own personal team. [screenshot](https://user-images.githubusercontent.com/6831096/229036174-ce1aafc1-fa53-4ec5-ae49-50b3d06ac875.png)
5. If you don't have one, just login to your apple account in Xcode will do, [screenshot](https://user-images.githubusercontent.com/6831096/229037314-4857c237-95b7-46bb-be5b-94921f17d2d9.png)
6. Select the `CourierService` target and run with `CMD+R`, [screenshot](https://user-images.githubusercontent.com/6831096/229038347-e2d4348c-393f-4b66-b04e-2de98dcb258d.png)
7. Your bottom panel will pop up and you can type your input there, [screenshot](https://user-images.githubusercontent.com/6831096/229043045-fca47fc2-e168-4e3e-ac70-e559023aba44.png)
8. For unit test, change to `CourierService Library Test` and start the testing with `CMD+U`





## Problem 1

I stored my logic in `CouponStore` with `checkForDiscountPercent` function.<br />
Key idea is to verify the `Package`'s attribute to pass the boolean test to get the `Coupon`'s discount.<br />
The `totalCost` for each package can be calculated using the formula given in the PDF.
  ```sh
  let totalCost = baseDeliveryCost + (package.weightInKG * weightChargedRate) + (package.distanceInKM * distanceChargedRate)
  ```
  ```sh
  public func checkForDiscountPercent(offerCode: String, weightInKG: Double, distanceInKM: Double) -> Double {
        guard let coupon = coupons.first(where: { $0.offerCode == offerCode }) else { return 0 }

        if distanceInKM >= coupon.minimumDistanceInKM &&
            distanceInKM <= coupon.maximumDistanceInKM &&
            weightInKG >= coupon.minimumWeightInKG &&
            weightInKG <= coupon.maximumWeightInKG {
            return coupon.discountPercent
        }

        return 0
    }
  ```





## Problem 2

I used a recursive looping mechanism to get the best possible packages to be delivered. Adding one package to the `populatingPackages` array at the time, get their total weight and distance and compare it with the previous populated `packagesPair`<br />
To have a clearer picture of my code's execute steps:
1. Go to `Environment.swift`, change the `type` to return `.development`
2. Run the project again, with `CMD+R`
3. Finish the program with your input at the bottom panel, or, you can use `addPackage` and `getPackageTotalDeliveryOutput` function in the `DeliveryViewModel` to instantly get the answer
4. `logger.debug` should start to print logs at the bottom panel, [screenshot](https://user-images.githubusercontent.com/6831096/229046365-ac974889-06d2-4c09-83d0-9197b6a0ecf8.png)
5. Search for `Fulfilling` comment text, that will be the key point to fulfil the `Delivery Criteria` in the PDF
