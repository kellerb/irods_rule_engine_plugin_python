def myTestRule(rule_args, callback, rei):
    select = global_vars['*Select'][1:-1]
    select_add = global_vars['*SelectAdd'][1:-1]
    fcn = global_vars['*Function'][1:-1]

    # Initial select is on COLL_NAME
    ret_val = callback.msiMakeGenQuery(select, "COLL_NAME like '/tempZone/home/rods/%%'", irods_types.GenQueryInp())
    genQueryInp = ret_val[PYTHON_RE_RET_ARGUMENTS][2]

    # Add select on sum(DATA_SIZE)
    ret_val = callback.msiAddSelectFieldToGenQuery(select_add, fcn, genQueryInp)
    genQueryInp = ret_val[PYTHON_RE_RET_ARGUMENTS][2]

    ret_val = callback.msiExecGenQuery(genQueryInp, irods_types.GenQueryOut())
    genQueryOut = ret_val[PYTHON_RE_RET_ARGUMENTS][1]

    for row in range(genQueryOut.rowCnt):
        coll = genQueryOut.sqlResult[0].row(row)
        size = genQueryOut.sqlResult[1].row(row)
        callback.writeLine('stdout', 'For collection ' + coll + ', the size of the files is ' + size)

INPUT *Select="COLL_NAME", *SelectAdd="DATA_SIZE", *Function="SUM"
OUTPUT ruleExecOut
