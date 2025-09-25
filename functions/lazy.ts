export default (pkg: string): any => (...args: any) => require(pkg).default(...args)
