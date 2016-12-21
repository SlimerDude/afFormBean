using build

class Build : BuildPod {

	new make() {
		podName = "afFormBean"
		summary = "Renders Fantom objects as HTML forms complete with client and server side validation"
		version = Version("1.1.7")

		meta = [
			"pod.displayName"	: "Form Bean",	
			"afIoc.module"		: "afFormBean::FormBeanModule",
			"repo.tags"			: "web",
			"repo.public"		: "true"
		]

		depends = [
			"sys 1.0.69 - 1.0",	// 1.0.69 because we make use of in-memory Files
			"web 1.0.69 - 1.0",

			// ---- Core ------------------------
			"afBeanUtils  1.0.8  - 1.0",
			"afConcurrent 1.0.12 - 1.0",	// for Messages.AtomicMap
			"afIoc        3.0.0  - 3.0",

			// ---- Web -------------------------
			"afBedSheet   1.5.0  - 1.5"
		]

		srcDirs = [`fan/`, `fan/advanced/`, `fan/internal/`, `fan/internal/inspectors/`, `fan/public/`]
		resDirs = [`doc/`, `res/`]
	}
}

