[getList]
SELECT * 
FROM pmis_performance_category
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[findById]
SELECT * FROM pmis_performance_category WHERE objid = $P{objid}
