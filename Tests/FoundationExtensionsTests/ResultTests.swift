// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import Foundation
import FoundationExtensions
import XCTest

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class ResultTests: XCTestCase {
    // MARK: - Protocol conformance tests

    func testResultValueInitializer() {
        // given
        let sut = Result<String, Error>.init(value: "Test")

        // then
        XCTAssertTrue(sut.isSuccess)
        switch sut {
        case .failure: XCTFail("Result should be successful")
        case let .success(value): XCTAssertEqual("Test", value)
        }
    }

    func testResultErrorInitializer() {
        // given
        let expectedError = AnyError()
        let sut = Result<String, Error>.init(error: expectedError)

        // then
        XCTAssertTrue(sut.isFailure)
        switch sut {
        case let .failure(error): XCTAssertEqual(expectedError, error as? AnyError)
        case .success: XCTFail("Result should be a failure")
        }
    }

    func testResultOfVoidSyntaxSugar() {
        // given
        let sut = Result<Void, Error>.success()

        // then
        XCTAssertTrue(sut.isSuccess)
        switch sut {
        case .failure: XCTFail("Result should be successful")
        case let .success(value): XCTAssert(value == ())
        }
    }

    func testIdentity() {
        // given
        let concreteType = Result<String, AnyError>.success("test")

        // when
        let sut = concreteType.asResult()

        // then
        XCTAssert(concreteType == sut)
    }

    // MARK: - Codable tests

    func testResultEncoder() {
        // given
        let encoder = JSONEncoder()

        // when
        let successCaseJson = String(data: (try? encoder.encode(successObject))!, encoding: .utf8)
        let failureCaseJson = String(data: (try? encoder.encode(failureObject))!, encoding: .utf8)

        // then
        XCTAssertTrue([successJson1, successJson2].contains(successCaseJson))
        XCTAssertEqual(failureCaseJson, failureJson)
    }

    func testResultDecoder() {
        // given
        let decoder = JSONDecoder()

        // when
        let successCase = try? decoder.decode(TestJson.self, from: successJson1.data(using: .utf8)!)
        let failureCase = try? decoder.decode(TestJson.self, from: failureJson.data(using: .utf8)!)

        // then
        XCTAssertEqual(successCase, successObject)
        XCTAssertEqual(failureCase, failureObject)
    }

    // MARK: - CustomStringConvertible and CustomDebugStringConvertible tests

    func testResultValueCustomString() {
        // given
        let result = Result<Int, AnyError>.success(42)

        // then
        let sut = result.description

        // then
        XCTAssertEqual("42", sut)
    }

    func testResultErrorCustomString() {
        // given
        let result = Result<Int, AnyError>.failure(AnyError())

        // then
        let sut = result.description

        // then
        XCTAssertEqual("The operation couldn’t be completed. (FoundationExtensionsTests.AnyError error 1.)", sut)
    }

    func testResultValueCustomDebugString() {
        // given
        let result = Result<Int, AnyError>.success(42)

        // then
        let sut = result.debugDescription

        // then
        XCTAssertEqual(".success(42)", sut)
    }

    func testResultErrorCustomDebugString() {
        // given
        let result = Result<Int, AnyError>.failure(AnyError())

        // then
        let sut = result.debugDescription

        // then
        XCTAssertEqual(".failure(The operation couldn’t be completed. (FoundationExtensionsTests.AnyError error 1.))", sut)
    }

    // MARK: - Equatable tests

    func testResultEquatableForString() {
        // given
        let sutA1: Result<String, String> = .success("a")
        let sutA2: Result<String, String> = .success("a")
        let sutB: Result<String, String> = .success("b")
        let sutC: Result<String, String> = .failure("a")

        // then
        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutB == sutC)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutC == sutB)

        // Inverse
        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutB != sutC)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutC != sutB)
    }

    func testResultEquatableForInt() {
        // given
        let sutA1: Result<Int, String> = .success(1)
        let sutA2: Result<Int, String> = .success(1)
        let sutB: Result<Int, String> = .success(2)
        let sutC: Result<Int, String> = .failure("1")

        // then
        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutB == sutC)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutC == sutB)

        // Inverse
        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutB != sutC)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutC != sutB)
    }

    func testResultEquatableForOptionalString() {
        // given
        let sutA1: Result<String?, String> = .success("a")
        let sutA2: Result<String?, String> = .success("a")
        let sutB: Result<String?, String> = .success("b")
        let sutC: Result<String?, String> = .failure("a")
        let sutD: Result<String?, String> = .success(nil)

        // then
        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutA1 == sutD)
        XCTAssertFalse(sutB == sutC)
        XCTAssertFalse(sutB == sutD)
        XCTAssertFalse(sutC == sutD)

        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutD == sutA1)
        XCTAssertFalse(sutC == sutB)
        XCTAssertFalse(sutD == sutB)
        XCTAssertFalse(sutD == sutC)

        XCTAssertTrue(sutC == .failure("a"))
        XCTAssertTrue(sutD == .success(nil))
        XCTAssertFalse(sutC != .failure("a"))
        XCTAssertFalse(sutD != .success(nil))

        // Inverse
        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutA1 != sutD)
        XCTAssertTrue(sutB != sutC)
        XCTAssertTrue(sutB != sutD)
        XCTAssertTrue(sutC != sutD)

        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutD != sutA1)
        XCTAssertTrue(sutC != sutB)
        XCTAssertTrue(sutD != sutB)
        XCTAssertTrue(sutD != sutC)
    }

    func testResultEquatableForArrayOfStrings() {
        // given
        let error = AnyError()
        let sutA1: Result<[String], AnyError> = .success(["a", "a"])
        let sutA2: Result<[String], AnyError> = .success(["a", "a"])
        let sutB: Result<[String], AnyError> = .success(["a", "b"])
        let sutC: Result<[String], AnyError> = .success(["b", "a"])
        let sutD: Result<[String], AnyError> = .failure(error)
        let sutE: Result<[String], AnyError> = .success([])

        // then
        XCTAssertTrue(sutA1 == sutA2)
        XCTAssertFalse(sutA1 == sutB)
        XCTAssertFalse(sutA1 == sutC)
        XCTAssertFalse(sutA1 == sutD)
        XCTAssertFalse(sutA1 == sutE)
        XCTAssertFalse(sutB == sutC)
        XCTAssertFalse(sutB == sutD)
        XCTAssertFalse(sutB == sutE)
        XCTAssertFalse(sutC == sutD)
        XCTAssertFalse(sutC == sutE)
        XCTAssertFalse(sutD == sutE)
        XCTAssertTrue(sutA2 == sutA1)
        XCTAssertFalse(sutB == sutA1)
        XCTAssertFalse(sutC == sutA1)
        XCTAssertFalse(sutD == sutA1)
        XCTAssertFalse(sutE == sutA1)
        XCTAssertFalse(sutC == sutB)
        XCTAssertFalse(sutD == sutB)
        XCTAssertFalse(sutE == sutB)
        XCTAssertFalse(sutD == sutC)
        XCTAssertFalse(sutE == sutC)
        XCTAssertFalse(sutE == sutD)

        XCTAssertTrue(sutD == .failure(error))
        XCTAssertFalse(sutD != .failure(error))
    }

    func testResultEquatableForArrayOfStringsInverse() {
        // given
        let sutA1: Result<[String], AnyError> = .success(["a", "a"])
        let sutA2: Result<[String], AnyError> = .success(["a", "a"])
        let sutB: Result<[String], AnyError> = .success(["a", "b"])
        let sutC: Result<[String], AnyError> = .success(["b", "a"])
        let sutD: Result<[String], AnyError> = .failure(AnyError())
        let sutE: Result<[String], AnyError> = .success([])

        // then
        XCTAssertFalse(sutA1 != sutA2)
        XCTAssertTrue(sutA1 != sutB)
        XCTAssertTrue(sutA1 != sutC)
        XCTAssertTrue(sutA1 != sutD)
        XCTAssertTrue(sutA1 != sutE)
        XCTAssertTrue(sutB != sutC)
        XCTAssertTrue(sutB != sutD)
        XCTAssertTrue(sutB != sutE)
        XCTAssertTrue(sutC != sutD)
        XCTAssertTrue(sutC != sutE)
        XCTAssertTrue(sutD != sutE)
        XCTAssertFalse(sutA2 != sutA1)
        XCTAssertTrue(sutB != sutA1)
        XCTAssertTrue(sutC != sutA1)
        XCTAssertTrue(sutD != sutA1)
        XCTAssertTrue(sutE != sutA1)
        XCTAssertTrue(sutC != sutB)
        XCTAssertTrue(sutD != sutB)
        XCTAssertTrue(sutE != sutB)
        XCTAssertTrue(sutD != sutC)
        XCTAssertTrue(sutE != sutC)
        XCTAssertTrue(sutE != sutD)
    }

    // MARK: - Associated values (Prism)

    func testMaybeValueInResultWithSuccess() {
        // given
        let value = "success"

        // when
        let sut = Result<String, AnyError>.success(value)

        // then
        XCTAssertEqual(value, sut.value)
    }

    func testMaybeValueInResultWithError() {
        // given
        let anyError = AnyError()

        // when
        let sut = Result<String, AnyError>.failure(anyError)

        // then
        XCTAssertNil(sut.value)
    }

    func testMaybeErrorInResultWithError() {
        // given
        let anyError = AnyError()

        // when
        let sut = Result<String, AnyError>.failure(anyError)

        // then
        XCTAssertEqual(anyError, sut.error)
    }

    func testMaybeErrorInResultWithSuccess() {
        // when
        let sut = Result<String, AnyError>.success("success")

        // then
        XCTAssertNil(sut.error)
    }

    func testBooleanStates() {
        // given
        let successful = Result<String, String>.success("yey!")
        let failure = Result<String, String>.failure("nooo!")

        // then
        XCTAssertEqual(successful.isSuccess, true)
        XCTAssertEqual(successful.isFailure, false)
        XCTAssertEqual(failure.isSuccess, false)
        XCTAssertEqual(failure.isFailure, true)
    }

    // MARK: - Foldable / Coproduct
    func testFoldSuccessfulResult() {
        // given
        let result = Result<Int, Error>.success(42)

        // when
        let foldedInteger: Int = result.fold(
            onSuccess: { value in
                XCTAssertEqual(42, value)
                return value + 1
            }, onFailure: { _ in
                XCTFail("Result was expected to succeed")
                return 0
            }
        )

        XCTAssertEqual(43, foldedInteger)
    }

    func testFoldFailureResult() {
        // given
        let expectedError = AnyError()
        let result = Result<Int, Error>.failure(expectedError)

        // when
        let foldedInteger: Int = result.fold(
            onSuccess: { value in
                XCTFail("Result was expected to fail")
                return value + 1
            }, onFailure: { error in
                XCTAssertEqual(expectedError, error as? AnyError)
                return 0
            }
        )

        XCTAssertEqual(0, foldedInteger)
    }

    func testAnalysisSuccessfulResult() {
        // given
        let result = Result<Int, AnyError>.success(42)

        // when
        let expectedToBeSelf = result.analysis(
            ifSuccess: { value in
                XCTAssertEqual(42, value)
            }, ifFailure: { _ in
                XCTFail("Result was expected to succeed")
            }
        )

        XCTAssertEqual(result, expectedToBeSelf)
    }

    func testAnalysisFailureResult() {
        // given
        let expectedError = AnyError()
        let result = Result<Int, AnyError>.failure(expectedError)

        // when
        let expectedToBeSelf = result.analysis(
            ifSuccess: { _ in
                XCTFail("Result was expected to fail")
            }, ifFailure: { error in
                XCTAssertEqual(expectedError, error)
            }
        )

        XCTAssertEqual(result, expectedToBeSelf)
    }

    func testOnFailureSuccessfulResult() {
        // given
        let result = Result<Int, AnyError>.success(42)

        // when
        let expectedToBeSelf = result.onError { _ in
            XCTFail("Result was expected to succeed")
        }

        XCTAssertEqual(result, expectedToBeSelf)
    }

    @MainActor
    func testOnFailureFailureResult() {
        // given
        let expectedError = AnyError()
        let result = Result<Int, AnyError>.failure(expectedError)
        let shouldCallBlock = expectation(description: "should have called the block")

        // when
        let expectedToBeSelf = result.onError { error in
            XCTAssertEqual(expectedError, error)
            shouldCallBlock.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(result, expectedToBeSelf)
    }

    // MARK: - Map (Functor), Bimap (Bifunctor), Apply (Applicative), FlatMap (Monad), BiFlatMap (Bimonad)

    func testResultMap() {
        // given
        let successfulInt1: Result<Int, AnyError> = .success(1)
        let successfulInt2: Result<Int, AnyError> = .success(2)
        let error = AnyError()
        let errorInt: Result<Int, AnyError> = .failure(error)

        // then
        XCTAssertTrue(successfulInt1.map(String.init) == .success("1"))
        XCTAssertTrue(successfulInt2.map(String.init) == .success("2"))
        XCTAssertTrue(errorInt.map(String.init) == .failure(error))
    }

    func testResultMapError() {
        // given
        let successfulInt1: Result<Int, String> = .success(1)
        let successfulInt2: Result<Int, String> = .success(2)
        let error = "3"
        let errorInt: Result<Int, String> = .failure(error)
        let fromStringToInt = { (e: String) in Int(e)! }

        // when
        let map1 = successfulInt1.mapError(fromStringToInt)
        let map2 = successfulInt2.mapError(fromStringToInt)
        let errorMap = errorInt.mapError(fromStringToInt)

        // then
        XCTAssertTrue(map1 == .success(1))
        XCTAssertTrue(map2 == .success(2))
        XCTAssertTrue(errorMap == .failure(3))
    }

    func testResultBiMap() {
        // given
        let successfulInt1: Result<Int, String> = .success(1)
        let successfulInt2: Result<Int, String> = .success(2)
        let error = "3"
        let errorInt: Result<Int, String> = .failure(error)
        let fromStringToInt = { (e: String) in Int(e)! }

        // when
        let map1 = successfulInt1.biMap(String.init, errorTransform: fromStringToInt)
        let map2 = successfulInt2.biMap(String.init, errorTransform: fromStringToInt)
        let errorMap = errorInt.biMap(String.init, errorTransform: fromStringToInt)

        // then
        XCTAssertTrue(map1 == .success("1"))
        XCTAssertTrue(map2 == .success("2"))
        XCTAssertTrue(errorMap == .failure(3))
    }

    func testResultFlatMap() {
        // given
        let successfulInt1: Result<Int, AnyError> = .success(1)
        let successfulInt2: Result<Int, AnyError> = .success(2)
        let lhsError = AnyError()
        let rhsError = AnyError()
        let errorInt: Result<Int, AnyError> = .failure(lhsError)

        func successfulFunc(_ input: Int) -> Result<String, AnyError> {
            return .success(String(input))
        }

        func errorFunc(_ input: Int) -> Result<String, AnyError> {
            return .failure(rhsError)
        }

        // when
        let successfulRhs1 = successfulInt1.flatMap(successfulFunc)
        let successfulRhs2 = successfulInt2.flatMap(successfulFunc)
        let failureLhs = errorInt.flatMap(successfulFunc)
        let failureRhs1 = successfulInt1.flatMap(errorFunc)
        let failureRhs2 = successfulInt2.flatMap(errorFunc)
        let failureBothEvaluateLhsOnly = errorInt.flatMap(errorFunc)

        // then
        XCTAssertTrue(successfulRhs1 == .success("1"))
        XCTAssertTrue(successfulRhs2 == .success("2"))
        XCTAssertTrue(failureLhs == .failure(lhsError))

        XCTAssertTrue(failureRhs1 == .failure(rhsError))
        XCTAssertTrue(failureRhs2 == .failure(rhsError))
        XCTAssertTrue(failureBothEvaluateLhsOnly == .failure(lhsError))
    }

    func testResultFlatMapError() {
        // given
        let successfulInt: Result<Int, String> = .success(1)
        let error = "3"
        let error2 = "Oops"
        let errorInt: Result<Int, String> = .failure(error)
        let errorNotInt: Result<Int, String> = .failure(error2)

        let fromStringToInt = { (e: String) in Result<Int, Int>.failure(Int(e) ?? -999) }

        // when
        let successFlatten = successfulInt.flatMapError(fromStringToInt)
        let errorFlatten = errorInt.flatMapError(fromStringToInt)
        let errorNotIntFlatten = errorNotInt.flatMapError(fromStringToInt)

        // then
        XCTAssertTrue(successFlatten == .success(1))
        XCTAssertTrue(errorFlatten == .failure(3))
        XCTAssertTrue(errorNotIntFlatten == Result<Int, Int>.failure(-999))
    }

    func testResultBiFlatMap() {
        // given
        let successfulInt1: Result<Int, String> = .success(1)
        let successfulInt2: Result<Int, String> = .success(2)
        let error = "3"
        let errorInt: Result<Int, String> = .failure(error)

        let transformSuccess = { (value: Int) -> Result<String, Int> in .success(String(value)) }
        let transformSuccessIntoFailure = { (value: Int) -> Result<String, Int> in .failure(4) }
        let fromStringToInt = { (e: String) in Result<String, Int>.failure(Int(e)!) }

        // when
        let successRhs1 = successfulInt1.biFlatMap(transformSuccess, errorTransform: fromStringToInt)
        let successRhs2 = successfulInt2.biFlatMap(transformSuccess, errorTransform: fromStringToInt)
        let errorLhs = errorInt.biFlatMap(transformSuccess, errorTransform: fromStringToInt)
        let errorRhs1 = successfulInt1.biFlatMap(transformSuccessIntoFailure, errorTransform: fromStringToInt)
        let errorRhs2 = successfulInt2.biFlatMap(transformSuccessIntoFailure, errorTransform: fromStringToInt)
        let errorBothSidesEvaluateLhsOnly = errorInt.biFlatMap(transformSuccessIntoFailure, errorTransform: fromStringToInt)

        // then
        XCTAssertTrue(successRhs1 == .success("1"))
        XCTAssertTrue(successRhs2 == .success("2"))
        XCTAssertTrue(errorLhs == Result<String, Int>.failure(3))

        XCTAssertTrue(errorRhs1 == Result<String, Int>.failure(4))
        XCTAssertTrue(errorRhs2 == Result<String, Int>.failure(4))
        XCTAssertTrue(errorBothSidesEvaluateLhsOnly == Result<String, Int>.failure(3))
    }

    func testFlattenLeftSuccessSuccess() {
        // given
        let result = Result<Result<String, AnyError>, AnyError>.success(.success("success"))

        // when
        let sut = result.flattenLeft()

        // then
        XCTAssertEqual(.success("success"), sut)
    }

    func testFlattenLeftSuccessFailure() {
        // given
        let error = AnyError()
        let result = Result<Result<String, AnyError>, AnyError>.success(.failure(error))

        // when
        let sut = result.flattenLeft()

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testFlattenLeftFailure() {
        // given
        let error = AnyError()
        let result = Result<Result<String, AnyError>, AnyError>.failure(error)

        // when
        let sut = result.flattenLeft()

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testApplySuccessfulTransformationOnSuccessfulResult() {
        // given
        let result = Result<String, AnyError>.success("42")
        let transformation = Result<(String) -> Int, AnyError>.success {
            Int.init($0)!
        }

        // when
        let sut: Result<Int, AnyError> = result.apply(transformation)

        // then
        XCTAssertEqual(.success(42), sut)
    }

    func testApplyFailureTransformationOnSuccessfulResult() {
        // given
        let result = Result<String, AnyError>.success("42")
        let error = AnyError()
        let transformation = Result<(String) -> Int, AnyError>.failure(error)

        // when
        let sut: Result<Int, AnyError> = result.apply(transformation)

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testApplySuccessfulTransformationOnFailureResult() {
        // given
        let error = AnyError()
        let result = Result<String, AnyError>.failure(error)
        let transformation = Result<(String) -> Int, AnyError>.success {
            Int.init($0)!
        }

        // when
        let sut: Result<Int, AnyError> = result.apply(transformation)

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testApplyFailureTransformationOnFailureResult() {
        // given
        let error1 = AnyError()
        let error2 = AnyError()
        let result = Result<String, AnyError>.failure(error1)
        let transformation = Result<(String) -> Int, AnyError>.failure(error2)

        // when
        let sut: Result<Int, AnyError> = result.apply(transformation)

        // then
        XCTAssertEqual(.failure(error1), sut)
    }

    func testCallSuccessfulResultWithSuccessfulTransformation() {
        // given
        let result = Result<String, AnyError>.success("42")
        let transformation = Result<(String) -> Int, AnyError>.success {
            Int.init($0)!
        }

        // when
        let sut: Result<Int, AnyError> = transformation.call(result)

        // then
        XCTAssertEqual(.success(42), sut)
    }

    func testCallSuccessfulResultWithFailureTransformation() {
        // given
        let result = Result<String, AnyError>.success("42")
        let error = AnyError()
        let transformation = Result<(String) -> Int, AnyError>.failure(error)

        // when
        let sut: Result<Int, AnyError> = transformation.call(result)

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testCallFailureResultWithSuccessfulTransformation() {
        // given
        let error = AnyError()
        let result = Result<String, AnyError>.failure(error)
        let transformation = Result<(String) -> Int, AnyError>.success {
            Int.init($0)!
        }

        // when
        let sut: Result<Int, AnyError> = transformation.call(result)

        // then
        XCTAssertEqual(.failure(error), sut)
    }

    func testCallFailureResultWithFailureTransformation() {
        // given
        let error1 = AnyError()
        let error2 = AnyError()
        let result = Result<String, AnyError>.failure(error1)
        let transformation = Result<(String) -> Int, AnyError>.failure(error2)

        // when
        let sut: Result<Int, AnyError> = transformation.call(result)

        // then
        XCTAssertEqual(.failure(error1), sut)
    }

    func testLiftResult() {
        // given
        let successfulInt1: Result<Int, AnyError> = .success(1)
        let successfulInt2: Result<Int, AnyError> = .success(2)
        let error = AnyError()
        let errorInt: Result<Int, AnyError> = .failure(error)
        let lift = Result<Int, AnyError>.lift(String.init)

        // then
        let success1 = lift(successfulInt1)
        let success2 = lift(successfulInt2)
        let failure = lift(errorInt)

        // then
        XCTAssertEqual(.success("1"), success1)
        XCTAssertEqual(.success("2"), success2)
        XCTAssertEqual(.failure(error), failure)
    }

    func testFlatLiftResult() {
        // given
        let successfulInt1: Result<Int, AnyError> = .success(1)
        let successfulInt2: Result<Int, AnyError> = .success(2)
        let lhsError = AnyError()
        let rhsError = AnyError()
        let errorInt: Result<Int, AnyError> = .failure(lhsError)

        func successfulFunc(_ input: Int) -> Result<String, AnyError> {
            return .success(String(input))
        }
        let successfulLift = Result<Int, AnyError>.flatLift(successfulFunc)

        func errorFunc(_ input: Int) -> Result<String, AnyError> {
            return .failure(rhsError)
        }
        let failureLift = Result<Int, AnyError>.flatLift(errorFunc)

        // when
        let successfulRhs1 = successfulLift(successfulInt1)
        let successfulRhs2 = successfulLift(successfulInt2)
        let failureLhs = successfulLift(errorInt)
        let failureRhs1 = failureLift(successfulInt1)
        let failureRhs2 = failureLift(successfulInt2)
        let failureBothEvaluateLhsOnly = failureLift(errorInt)

        // then
        XCTAssertTrue(successfulRhs1 == .success("1"))
        XCTAssertTrue(successfulRhs2 == .success("2"))
        XCTAssertTrue(failureLhs == .failure(lhsError))

        XCTAssertTrue(failureRhs1 == .failure(rhsError))
        XCTAssertTrue(failureRhs2 == .failure(rhsError))
        XCTAssertTrue(failureBothEvaluateLhsOnly == .failure(lhsError))
    }

    func testUpcastErrorOnSuccessfulResult() {
        // given
        let result = Result<String, AnyError>.success("boo")

        // when
        let sut = result.upcastError()

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertFalse(sut.isFailure)
        XCTAssertEqual("boo", sut.value)
        XCTAssertNil(sut.error)
    }

    func testUpcastErrorOnFailureResult() {
        // given
        let anyError = AnyError()
        let result = Result<String, AnyError>.failure(anyError)

        // when
        let sut = result.upcastError()

        // then
        XCTAssertFalse(sut.isSuccess)
        XCTAssertTrue(sut.isFailure)
        XCTAssertNil(sut.value)
        XCTAssertNotNil(sut.error as? AnyError)
        XCTAssert(anyError == (sut.error as? AnyError))
    }

    // MARK: - Materialization

    func testResultOfSuccessfulMaterialization() {
        // given
        func operation() throws -> String {
            return "Success!!"
        }

        // when
        let sut = Result(catching: operation)

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertEqual("Success!!", sut.value)
    }

    func testResultOfFailureMaterialization() {
        // given
        func operation() throws -> String {
            throw AnyError()
        }

        // when
        let sut = Result(catching: operation)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertNotNil(sut.error as? AnyError)
    }

    func testResultOfSuccessfulDematerialization() {
        // given
        let result = Result<String, Error>.success("Success!!")

        // when
        let sut = try! result.get() // swiftlint:disable:this force_try

        // then
        XCTAssertEqual("Success!!", sut)
    }

    func testResultOfFailureDematerialization() {
        // given
        let expectedError = AnyError()
        let result = Result<String, Error>.failure(expectedError)

        // when
        do {
            _ = try result.get()
            XCTFail("Operation expected to throw")
        } catch {
            // then
            XCTAssertEqual(expectedError, error as? AnyError)
        }
    }

    // MARK: - Recoverable

    func testResultCoalesceToResultT() {
        // given
        let sutA: Result<String, AnyError> = .success("a")
        let sutB: Result<String, AnyError> = .success("b")
        let sutC: Result<String, AnyError> = .failure(AnyError())
        let sutD: Result<String, AnyError> = .failure(AnyError())

        // then
        XCTAssertTrue((sutA ?? sutB).value == "a")
        XCTAssertTrue((sutA ?? sutC).value == "a")
        XCTAssertTrue((sutA ?? sutD).value == "a")

        XCTAssertTrue((sutB ?? sutA).value == "b")
        XCTAssertTrue((sutB ?? sutC).value == "b")
        XCTAssertTrue((sutB ?? sutD).value == "b")

        XCTAssertTrue((sutC ?? sutA).value == "a")
        XCTAssertTrue((sutC ?? sutB).value == "b")
        XCTAssertTrue((sutC ?? sutD).value == nil)

        XCTAssertTrue((sutD ?? sutA).value == "a")
        XCTAssertTrue((sutD ?? sutB).value == "b")
        XCTAssertTrue((sutD ?? sutC).value == nil)

        // Repeat but with nil prefix
        XCTAssertTrue((sutC ?? sutA ?? sutB).value == "a")
        XCTAssertTrue((sutC ?? sutA ?? sutC).value == "a")
        XCTAssertTrue((sutC ?? sutA ?? sutD).value == "a")

        XCTAssertTrue((sutC ?? sutB ?? sutA).value == "b")
        XCTAssertTrue((sutC ?? sutB ?? sutC).value == "b")
        XCTAssertTrue((sutC ?? sutB ?? sutD).value == "b")

        XCTAssertTrue((sutD ?? sutC ?? sutA).value == "a")
        XCTAssertTrue((sutD ?? sutC ?? sutB).value == "b")
        XCTAssertTrue((sutD ?? sutC ?? sutD).value == nil)

        XCTAssertTrue((sutC ?? sutD ?? sutA).value == "a")
        XCTAssertTrue((sutC ?? sutD ?? sutB).value == "b")
        XCTAssertTrue((sutC ?? sutD ?? sutC).value == nil)
    }

    func testResultCoalesceToT() {
        // given
        let sutA: Result<String, AnyError> = .success("a")
        let sutB: Result<String, AnyError> = .failure(AnyError())
        let sutC = "c"

        // then
        XCTAssertTrue(sutA ?? sutC == "a")
        XCTAssertTrue(sutB ?? sutC == "c")

        // Repeat but with nil prefix
        XCTAssertTrue(sutB ?? sutA ?? sutC == "a")
    }

    func testResultCoalesceToOptionalT() {
        // given
        let sutA: Result<String, AnyError> = .success("a")
        let sutB: Result<String, AnyError> = .failure(AnyError())
        let sutC: String? = "c"
        let sutD: String? = nil

        // then
        XCTAssertTrue(sutA.value ?? sutC == "a")
        XCTAssertTrue(sutA.value ?? sutD == "a")

        XCTAssertTrue(sutB.value ?? sutC == "c")
        XCTAssertTrue(sutB.value ?? sutD == nil)

        // Repeat but with nil prefix
        XCTAssertTrue(sutB.value ?? sutA.value ?? sutC == "a")
        XCTAssertTrue(sutB.value ?? sutA.value ?? sutD == "a")

        XCTAssertTrue(sutB.value ?? sutB.value ?? sutC == "c")
        XCTAssertTrue(sutB.value ?? sutB.value ?? sutD == nil)
    }

    // MARK: - Zipable

    func testZip2SuccessOnly() {
        // given
        let lhs = Result<String, Error>.success("lhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, rhs)

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertTrue(("lhs success", "rhs success") == sut.value!)
    }

    func testZip2LhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.failure(error)
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testZip2RhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.success("lhs success")
        let rhs = Result<String, Error>.failure(error)

        // when
        let sut = zip(lhs, rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testZip3SuccessOnly() {
        // given
        let lhs = Result<String, Error>.success("lhs success")
        let mhs = Result<String, Error>.success("mhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, mhs, rhs)

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertTrue(("lhs success", "mhs success", "rhs success") == sut.value!)
    }

    func testZip3LhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.failure(error)
        let mhs = Result<String, Error>.success("mhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, mhs, rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testZip3RhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.success("lhs success")
        let mhs = Result<String, Error>.success("mhs success")
        let rhs = Result<String, Error>.failure(error)

        // when
        let sut = zip(lhs, mhs, rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testZip4SuccessOnly() {
        // given
        let lhs = Result<String, Error>.success("lhs success")
        let mlhs = Result<String, Error>.success("mlhs success")
        let mrhs = Result<String, Error>.success("mrhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, mlhs, mrhs, rhs)

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertTrue(("lhs success", "mlhs success", "mrhs success", "rhs success") == sut.value!)
    }

    func testZip4LhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.failure(error)
        let mlhs = Result<String, Error>.success("mlhs success")
        let mrhs = Result<String, Error>.success("mrhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = zip(lhs, mlhs, mrhs, rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testFanoutSuccessOnly() {
        // given
        let lhs = Result<String, Error>.success("lhs success")
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = lhs.fanout(rhs)

        // then
        XCTAssertTrue(sut.isSuccess)
        XCTAssertTrue(("lhs success", "rhs success") == sut.value!)
    }

    func testFanoutLhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.failure(error)
        let rhs = Result<String, Error>.success("rhs success")

        // when
        let sut = lhs.fanout(rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    func testFanoutRhsFailure() {
        // given
        let error = AnyError()
        let lhs = Result<String, Error>.success("lhs success")
        let rhs = Result<String, Error>.failure(error)

        // when
        let sut = lhs.fanout(rhs)

        // then
        XCTAssertTrue(sut.isFailure)
        XCTAssertEqual(error, sut.error as? AnyError)
    }

    // MARK: - Sequence extensions
    func testFlatMapResultArraySuccessOnly() {
        // given
        let originalResult: Result<[Int], Int> = .success([1, 2, 3, 5, 8, 13, 21, 34, 55, 89])
        let expectedResult: Result<[String], Int> = .success(["1", "2", "3", "5", "8", "13", "21", "34", "55", "89"])

        // when
        let transformed = originalResult.flatMap { int in .success(String(int)) }

        // then
        XCTAssertEqual(expectedResult, transformed)
    }

    func testFlatMapResultArrayWithOneFailure() {
        // given
        let anyError = "This is an error"
        let originalResult: Result<[Int], String> = .success([1, 2, 3, 5, 8, 13, 21, 34, 55, 89])

        // when
        let transformed: Result<[String], String> = originalResult.flatMap { (int: Int) -> Result<String, String> in
            switch int {
            case 13: return .failure(anyError)
            case 14...:
                XCTFail("After first failure, the evaluation should stop")
                return .success(String(int))
            default:
                return .success(String(int))
            }
        }

        // then
        transformed.expectedToFail(with: anyError)
    }

    func testFlatMapResultArrayWithInitialFailure() {
        // given
        let newError = "This is a new error"
        let originalError = "This is the original error"
        let originalResult: Result<[Int], String> = .failure(originalError)

        // when
        let transformed: Result<[String], String> = originalResult.flatMap { (_: Int) -> Result<String, String> in
            XCTFail("After first failure, the evaluation should stop")
            return .failure(newError)
        }

        // then
        transformed.expectedToFail(with: originalError)
    }

    // MARK: - Traverse

    func testTraverseResultResult() {
        // given
        let initialSuccess = Result<Int, Int>.success(1)
        let initialFailure = Result<Int, Int>.failure(0)
        let successfulTransform: (Int) -> Result<String, String> = { .success("\($0)") }
        let failureTransform: (Int) -> Result<String, String> = { .failure("\($0)") }

        // when
        let successThenSuccess = initialSuccess.traverse(successfulTransform)
        let successThenFailure = initialSuccess.traverse(failureTransform)
        let failureThenSuccess = initialFailure.traverse(successfulTransform)
        let failureThenFailure = initialFailure.traverse(failureTransform)

        // then
        XCTAssertEqual(.success(.success("1")), successThenSuccess)
        XCTAssertEqual(.failure("1"), successThenFailure)
        XCTAssertEqual(.success(.failure(0)), failureThenSuccess)
        XCTAssertEqual(.success(.failure(0)), failureThenFailure)
    }

    func testTraverseResultArray() {
        // given
        let initialSuccess = Result<Int, Int>.success(4)
        let initialFailure = Result<Int, Int>.failure(5)
        let transform: (Int) -> [String] = { (1...$0).map { "\($0)" } }

        // when
        let successTransform = initialSuccess.traverse(transform)
        let failureTransform = initialFailure.traverse(transform)

        // then
        XCTAssertEqual([.success("1"), .success("2"), .success("3"), .success("4")], successTransform)
        XCTAssertEqual([.failure(5)], failureTransform)
    }

    func testTraverseResultOptional() {
        // given
        let initialSuccess = Result<Int, Int>.success(1)
        let initialFailure = Result<Int, Int>.failure(0)
        let successfulTransform: (Int) -> String? = { "\($0)" }
        let failureTransform: (Int) -> String? = { _ in nil }

        // when
        let successThenSuccess = initialSuccess.traverse(successfulTransform)
        let successThenFailure = initialSuccess.traverse(failureTransform)
        let failureThenSuccess = initialFailure.traverse(successfulTransform)
        let failureThenFailure = initialFailure.traverse(failureTransform)

        // then
        XCTAssertEqual(.success("1"), successThenSuccess)
        XCTAssertNil(successThenFailure)
        XCTAssertEqual(.failure(0), failureThenSuccess)
        XCTAssertEqual(.failure(0), failureThenFailure)
    }
}
#endif
