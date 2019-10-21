local m = require 'init'
local coder = require 'coder'
local util = require'util'

local parser = [[
    parser                      <-      statement EOF
    statement                   <-      (block / variableStatement / emptyStatement / expressionStatement / ifStatement 
                                        / iterationStatement / breakStatment)
    block                       <-      '{' statementList? '}'
    statementList               <-      statement+
    variableStatement           <-      varModifier variableDeclarationList eos 
    varModifier                 <-      Var / Let / Const
    variableDeclarationList     <-      variableDeclaration (',' variableDeclaration)*
    variableDeclaration         <-      (Identifier / arrayLiteral) ('=' singleExpression)?
    arrayLiteral                <-      ('[' elementList? ']')
    elementList                 <-      singleExpression (','+ singleExpression)* (','+ lastElement)?  /  lastElement
    singleExpression            <-      Identifier / 
                                        literal /
                                        arrayLiteral /
                                        This /
                                        Super /
                                        '(' expressionSequence ')' --/
                        --                singleExpression '[' expressionSequence ']' /
                        --                singleExpression '++' /
                        --                singleExpression '--' /
                        --                Delete singleExpression /
                        --                Void singleExpression /
                        --                Typeof singleExpression /
                        --                '++' singleExpression /
                        --                '--' singleExpression /
                        --                '+' singleExpression /
                        --                '-' singleExpression /
                        --                '~' singleExpression /
                        --                '!' singleExpression /
                        --                singleExpression ('*' / '/' / '%') singleExpression /
                        --                singleExpression ('+' / '-') singleExpression /
                        --                singleExpression ('<<' / '>>' / '>>>') singleExpression /
                        --                singleExpression ('<' / '>' / '<=' / '>=') singleExpression /
                        --                singleExpression Instanceof singleExpression /
                        --                singleExpression In singleExpression /
                        --                singleExpression ('==' / '!=' / '===' / '!==') singleExpression /
                        --                singleExpression '&' singleExpression /                   
                        --                singleExpression '^' singleExpression /                                
                        --                singleExpression '|' singleExpression /                                 
                        --                singleExpression '&&' singleExpression /                                
                        --                singleExpression '||' singleExpression /                                
                        --                singleExpression '?' singleExpression ':' singleExpression /          
                        --                singleExpression '=' singleExpression
    literal                     <-      NullLiteral / 
                                        BooleanLiteral /
                                        DecimalLiteral
    NullLiteral                 <-      'null'
    BooleanLiteral              <-      'true' / 'false'
    DecimalLiteral              <-      DecimalIntegerLiteral ('.' [0-9]*)?
    DecimalIntegerLiteral       <-      '0' / [1-9] [0-9]*
    lastElement                 <-      '...' (Identifier / singleExpression)
    eos                         <-      SemiColon / '}' / EOF
    emptyStatement              <-      SemiColon       
    SemiColon                   <-      ';'
    EOF                         <-      !.
    expressionStatement         <-      !('{' / Function)? expressionSequence eos
    Function                    <-      'function'
    expressionSequence          <-      singleExpression (',' singleExpression)*
    ifStatement                 <-      If '(' expressionSequence ')' statement (Else statement)?
    Identifier                  <-      [a-zA-Z][a-zA-z0-9]*
    Int                         <-      [0-9]+
    If                          <-      'if'
    Else                        <-      'else'
    iterationStatement          <-      Do statement While '(' expressionSequence ')' eos /
                                        While '(' expressionSequence ')' statement /
                                        For '(' expressionSequence? SemiColon expressionSequence? SemiColon expressionSequence? ')' statement /
                                        For '(' varModifier variableDeclarationList SemiColon expressionSequence? SemiColon expressionSequence? ')' statement
    breakStatment               <-      Break Identifier? eos

--keywords
    
    Var                         <-      'var'
    Let                         <-      'let' 
    Const                       <-      'const'
    Do                          <-      'do'
    While                       <-      'while'
    For                         <-      'for'
    Break                       <-      'break'
    This                        <-      'this'
    Super                       <-      'super'
    Delete                      <-      'delete'
    Void                        <-      'void'
    Typeof                      <-      'typeof'
    Instanceof                  <-      'instanceof'
    In                          <-      'in'
]]  


g, lab, pos = m.match(parser)
print(g, lab, pos)

--gerar o parser
local p = coder.makeg(g)        

local dir = lfs.currentdir() .. '/yes/'
util.testYes(dir, 'js', p)

dir = lfs.currentdir() .. '/no/'
util.testNo(dir, 'js', p)
