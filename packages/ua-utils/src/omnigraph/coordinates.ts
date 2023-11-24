import { OmniVector, OmniPoint } from './types'

/**
 * Compares two points by value
 *
 * @param a `OmniPoint`
 * @param b `OmniPoint`
 *
 * @returns `true` if the vector point to the same point in omniverse
 */
export const arePointsEqual = (a: OmniPoint, b: OmniPoint): boolean => a.address === b.address && a.eid === b.eid

/**
 * Compares two vectors by value
 *
 * @param a `OmniVector`
 * @param b `OmniVector`
 *
 * @returns `true` if the vector point from and to the same point in omniverse
 */
export const areVectorsEqual = (a: OmniVector, b: OmniVector): boolean =>
    arePointsEqual(a.from, b.from) && arePointsEqual(a.to, b.to)

/**
 * Serializes a point. Useful for when points need to be used in Map
 * where we cannot adjust the default behavior of using a reference equality
 *
 * @param point `OmniPoint`
 *
 * @returns `string`
 */
export const serializePoint = ({ address, eid }: OmniPoint): string => `${eid}|${address}`

/**
 * Serializes a vector. Useful for when vectors need to be used in Map
 * where we cannot adjust the default behavior of using a reference equality
 *
 * @param point `OmniVector`
 *
 * @returns `string`
 */
export const serializeVector = ({ from, to }: OmniVector): string => `${serializePoint(from)} → ${serializePoint(to)}`