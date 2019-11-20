local m = require 'init'
local coder = require 'coder'
local util = require'util'

local parser = [[
    parser                      <-      sourceElements? EOF

    sourceElement               <-      statement

    statement                   <-      block / variableStatement / importStatement / exportStatement / 
                                        emptyStatement / classDeclaration / expressionStatement / ifStatement / 
                                        iterationStatement / continueStatement / breakStatment / returnStatement /
                                        yieldStatement / withStatement / labelledStatement / switchStatement /
                                        throwStatement / tryStatement / debuggerStatement / functionDeclaration

    block                       <-      '{' statementList? '}'

    statementList               <-      statement+

    importStatement             <-      Import importFromBlock

    importFromBlock             <-      importDefault? (importNamespace / moduleItens) importFrom eos / StringLiteral eos

    moduleItens                 <-      '{' (aliasName ',')* (aliasName ','?)? '}'

    importDefault               <-      aliasName ','

    importNamespace             <-      '*' (As identifierName)?

    importFrom                  <-      From StringLiteral

    aliasName                   <-      identifierName (As identifierName)?

    exportStatement             <-      Export (exportFromBlock / declaration) eos / Export Default singleExpression eos

    exportFromBlock             <-      importNamespace importFrom eos / moduleItens importFrom? eos 

    declaration                 <-      variableStatement / classDeclaration / functionDeclaration

    variableStatement           <-      varModifier variableDeclarationList eos

    variableDeclarationList     <-      variableDeclaration (',' variableDeclaration)*

    variableDeclaration         <-      assignable ('=' singleExpression)?
    
    emptyStatement              <-      SemiColon

    expressionStatement         <-      !('{' / Function) expressionSequence eos

    ifStatement                 <-      If '(' expressionSequence ')' statement (Else statement)?


    iterationStatement          <-      Do statement While '(' expressionSequence ')' eos /
                                        While '(' expressionSequence ')' statement /
                                        For '(' (expressionSequence / variableStatement)? ';' expressionSequence? ';' expressionSequence? ')' statement /
                                        For '(' (singleExpression / variableStatement) In expressionSequence ')' statement /
                                        For Await? '(' (singleExpression / variableStatement) Identifier? expressionSequence ')' statement
                                    
    varModifier                 <-      Var / Let / Const

    continueStatement           <-      Continue Identifier? eos

    breakStatment               <-      Break Identifier? eos

    returnStatement             <-      Return expressionSequence? eos 

    yieldStatement              <-      Yield expressionSequence? eos

    withStatement               <-      With '(' expressionSequence ')' statement

    switchStatement             <-      Switch '(' expressionSequence ')' caseBlock

    caseBlock                   <-      '{' caseClauses? (defaultClause caseClauses?)? '}'

    caseClauses                 <-      caseClause+
    
    caseClause                  <-      Case expressionSequence ':' statementList?
    
    defaultClause               <-      Default ':' statementList?
    
    labelledStatement           <-      Identifier ':' statement

    throwStatement              <-      Throw expressionSequence eos
    
    tryStatement                <-      Try block (cathProduction finallyProduction? / finallyProduction)
    
    cathProduction              <-      Catch ('(' assignable? ')')? block
    
    finallyProduction           <-      Finally block
    
    debuggerStatement           <-      Debugger eos
    
    functionDeclaration         <-      Async? Function '*'? Identifier '(' formalParameterList? ')' '{' functionBody '}'
    
    classDeclaration            <-      Class Identifier classTail
    
    classTail                   <-      (Extends singleExpression)? '{' classElement* '}'
    
    classElement                <-      (Static / Identifier / Async)* methodDefinition / 
                                        emptyStatement / 
                                        '#'? propertyName '=' singleExpression

    methodDefinition            <-      '*'? '#'? propertyName '(' formalParameterList? ')' '{' functionBody '}' /
                                        '*'? '#'? getter '(' ')' '{' functionBody '}' /
                                        '*'? '#'? setter '(' formalParameterList? ')' '{' functionBody '}'

    formalParameterList         <-      formalParameterArg (',' formalParameterArg)* (',' lastFormalParameterArg)? /
                                        lastFormalParameterArg
    
    formalParameterArg          <-      assignable ('=' singleExpression)?
    
    lastFormalParameterArg      <-      Ellipsis singleExpression

    functionBody                <-      sourceElements? 

    sourceElements              <-      sourceElement+
    
    arrayLiteral                <-      ('[' elementList? ']')

    elementList                 <-      ','* arrayElement? (','+ arrayElement)* ','*

    arrayElement                <-      Ellipsis? singleExpression

    objectLiteral               <-      '{' (propertyAssignment (',' propertyAssignment)*)? ','? '}'
    
    propertyAssignment          <-      propertyName ':' singleExpression /
                                        '[' singleExpression ']' ':' singleExpression /
                                        Async? '*'? propertyName '(' formalParameterList? ')' '{' functionBody '}' /
                                        getter '(' ')' '{' functionBody '}' /
                                        setter '(' formalParameterArg ')' '{' functionBody '}' /
                                        Ellipsis? singleExpression

    propertyName                <-      identifierName / StringLiteral / numericLiteral / '[' singleExpression ']'

    arguments                   <-      '('(argument (',' argument)* ','?)?')'

    argument                    <-      Ellipsis? (singleExpression / Identifier)

    expressionSequence          <-      singleExpression (',' singleExpression)*

    singleExpression            <-      simpleSingleExpression/
                                        recursiveSingleExpression

    simpleSingleExpression      <-      anoymousFunction
                                        Class Identifier? classTail /
                                        New singleExpression arguments? /
                                        New '.' Identifier /
                                        Delete singleExpression /
                                        Void singleExpression /
                                        Typeof singleExpression /
                                        '++' singleExpression /
                                        '--' singleExpression /
                                        '+' singleExpression /
                                        '-' singleExpression /
                                        '~' singleExpression /
                                        '!' singleExpression /
                                        Await singleExpression /
                                        Import '(' singleExpression ')' /
                                        yieldStatement /
                                        This /
                                        Identifier / 
                                        Super / 
                                        literal /
                                        arrayLiteral / 
                                        objectLiteral / 
                                        '(' expressionSequence ')'

    recursiveSingleExpression   <-      simpleSingleExpression '[' expressionSequence ']' /
                                        simpleSingleExpression '?'? '.' '#'? identifierName /
                                        simpleSingleExpression arguments /
                                        simpleSingleExpression '++' /
                                        simpleSingleExpression '--' /
                                        simpleSingleExpression ('*' / '/' / '%') singleExpression /
                                        simpleSingleExpression ('+' / '-') singleExpression /
                                        singleExpression '??' singleExpression /
                                        simpleSingleExpression ('<<' / '>>' / '>>>') singleExpression /
                                        simpleSingleExpression ('<' / '>' / '<=' / '>=') singleExpression /
                                        simpleSingleExpression Instanceof singleExpression /
                                        simpleSingleExpression In singleExpression /
                                        simpleSingleExpression ('==' / '!=' / '===' / '!==') singleExpression /
                                        simpleSingleExpression '&' singleExpression /                   
                                        simpleSingleExpression '^' singleExpression /                                
                                        simpleSingleExpression '|' singleExpression /                                 
                                        simpleSingleExpression '&&' singleExpression /                                
                                        simpleSingleExpression '||' singleExpression /                                
                                        simpleSingleExpression '?' singleExpression ':' singleExpression /          
                                        simpleSingleExpression '=' singleExpression /
                                        simpleSingleExpression assignmentOperator singleExpression

    assignable                  <-      Identifier / arrayLiteral / objectLiteral

    anoymousFunction            <-      functionDeclaration /
                                        Async? Function '*'? '(' formalParameterList ')' '{' functionBody '}' /
                                        Async? arrowFunctionParameters '=>' arrowFunctionBody

    arrowFunctionParameters     <-      Identifier / '(' formalParameterList? ')'

    arrowFunctionBody           <-      singleExpression /  '{' functionBody '}' 

    assignmentOperator          <-      '*=' / '/=' ? '%=' / '+=' / '-=' / '<<=' /
                                        '>>=' / '>>>=' / '&=' / '^=' / '/=' / '**='

    literal                     <-      NullLiteral / 
                                        BooleanLiteral /
                                        numericLiteral /
                                        StringLiteral

    numericLiteral              <-      DecimalLiteral

    identifierName              <-      Identifier / reservedWord

    reservedWord                <-      keyword / NullLiteral / BooleanLiteral

    keyword                     <-      Break / Do / Instanceof / Typeof / Case / Else / New / Var / Catch / Finally /
                                        Return / Void / Continue / For / Switch / While / Debugger / Function / This /
                                        With /  Default / If / Throw / Delete / In / Try / Class / Enum / Extends /
                                        Super / Const / Export / Import / Implements / Let / Private / Public / 
                                        Interface / Package / Protected / Static / Yield / Async / Await / From / As

    getter                      <-      Identifier 'get'& propertyName
    
    setter                      <-      Identifier 'set'& propertyName

    eos                         <-      SemiColon / '}' / EOF / %s
     


--Lexer
    
    NullLiteral                 <-      'null'
    BooleanLiteral              <-      'true' / 'false'
    DecimalLiteral              <-      DecimalIntegerLiteral ('.' [0-9]*)?
    DecimalIntegerLiteral       <-      '0' / [1-9] [0-9]*
    StringLiteral               <-      '"' (!'"' .)* '"'
    SemiColon                   <-      ';'
    EOF                         <-      !.
    Identifier                  <-      [a-zA-Z][a-zA-z0-9]*
    Int                         <-      [0-9]+
    Multiply                    <-      '*'
    Ellipsis                    <-      '...'


--keywords

    Break                       <-      'break'
    Do                          <-      'do'
    Instanceof                  <-      'instanceof'
    Typeof                      <-      'typeof'
    Case                        <-      'case'
    Else                        <-      'else'
    New                         <-      'new'
    Var                         <-      'var'
    Catch                       <-      'catch'
    Finally                     <-      'finally'
    Return                      <-      'return'
    Void                        <-      'void'
    Continue                    <-      'continue'
    For                         <-      'for'
    Switch                      <-      'switch'
    While                       <-      'while'
    Debugger                    <-      'debugger'
    Function                    <-      'function'
    This                        <-      'this'
    With                        <-      'with'
    Default                     <-      'default'
    If                          <-      'if'
    Throw                       <-      'throw'
    Delete                      <-      'delete'
    In                          <-      'in'
    Try                         <-      'try'
    As                          <-      'as'
    From                        <-      'from'
    
    Class                       <-      'class'
    Enum                        <-      'enum'
    Extends                     <-      'extends'
    Super                       <-      'super'
    Const                       <-      'const'
    Export                      <-      'export'
    Import                      <-      'import'
    
    Async                       <-      'async'
    Await                       <-      'await'

    Implements                  <-      'implements' 
    Let                         <-      'let' 
    Private                     <-      'private' 
    Public                      <-      'public' 
    Interface                   <-      'interface' 
    Package                     <-      'package' 
    Protected                   <-      'protected' 
    Static                      <-      'static' 
    Yield                       <-      'yield' 

]]  


g, lab, pos = m.match(parser)
print(g, lab, pos)

--gerar o parser
local p = coder.makeg(g)        

local dir = lfs.currentdir() .. '/yes/'
util.testYes(dir, 'js', p)

dir = lfs.currentdir() .. '/no/'
util.testNo(dir, 'js', p)