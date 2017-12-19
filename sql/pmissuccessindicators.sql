[getRootNodes]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.parentid IS NULL AND  node.type='pmis'
GROUP BY node.title
ORDER BY node.lft

[getRootNodes1]
SELECT a.* FROM pmis_successindicators a  WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid IS NULL and a.type='pmis' ORDER BY a.code

[getChildNodes]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.parentid=$P{objid} AND node.type <> 'document'
GROUP BY node.title
ORDER BY node.lft

[getChildNodes1]
SELECT a.* FROM pmis_successindicators a WHERE 
a.parentid=$P{objid} AND a.type='pmis' ORDER BY a.code

[getList]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.parentid=$P{objid}
GROUP BY node.title
ORDER BY node.lft

[getList1]
SELECT * FROM pmis_successindicators WHERE 
orgid IN ('ROOT',$P{orgid}) AND parentid=$P{objid} ORDER BY code 

[getListDetails]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext}) AND  node.type='op'
GROUP BY node.title
ORDER BY node.lft

[getListDetails1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM pmis_successindicators WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM pmis_successindicators WHERE 
  title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND  a.type='op'
ORDER BY a.code 

[getSearch]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
GROUP BY node.title
ORDER BY node.lft

[getSearch1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM pmis_successindicators WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM pmis_successindicators WHERE 
  title LIKE $P{searchtext}
) a
WHERE a.orgid IN ('ROOT',$P{orgid})
ORDER BY a.code 

[findInfo]
SELECT a.*, p.code AS parent_code, p.title AS parent_title 
FROM pmis_successindicators a
LEFT JOIN pmis_successindicators p ON a.parentid = p.objid
WHERE a.objid=$P{objid}

[getLookup]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`lft`,node.`rgt`
FROM pmis_successindicators AS node,
        pmis_successindicators AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid = $P{orgid} AND node.type <> 'document'
GROUP BY node.title
ORDER BY node.lft

[getLookup1]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid}
	UNION
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid} 
) a
ORDER BY a.code

[getLookupForMapping]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} 
	UNION
	SELECT objid,code,title,type FROM pmis_successindicators t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.type IN ( 'op', 'subaccount' )
ORDER BY a.code

[approve]
UPDATE pmis_successindicators SET state='APPROVED' WHERE 
objid=$P{objid} 

[changeParent]
UPDATE pmis_successindicators SET parentid=$P{parentid},lft=$P{lft},rgt=$P{rgt} WHERE 
objid=$P{objid} 

[getSubAccounts]
SELECT a.* FROM pmis_successindicators a WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code

[getRevenueItemList]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN pmis_successindicators a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.title LIKE $P{searchtext} 
ORDER BY r.code

[getRevenueItemListByCode]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN pmis_successindicators a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.code LIKE $P{searchtext} 
ORDER BY r.code

[getAccountpmiss]
SELECT 
  objid,
  CASE WHEN parentid IS NULL THEN 'ROOT' ELSE parentid END AS parentid,
  code,
  title,
  type,
  0 AS amount 
FROM pmis_successindicators 
ORDER BY code


[findParent]
SELECT * FROM pmis_successindicators WHERE objid = $P{parentid}

[changeNodeRight]
UPDATE pmis_successindicators SET rgt = rgt + 2 WHERE rgt > $P{myRight}

[changeNodeLeft]
UPDATE pmis_successindicators SET lft = lft + 2 WHERE lft > $P{myRight}

[changeParentRight]
UPDATE pmis_successindicators SET rgt = rgt + 2 WHERE rgt > $P{myLeft}

[changeParentLeft]
UPDATE pmis_successindicators SET lft = lft + 2 WHERE lft > $P{myLeft}

[getSuccessIndicatorOrg]
SELECT * FROM pmis_successindicators_org WHERE siid = $P{xxx}

[deleteSuccessIndicatorOrg]
DELETE FROM pmis_successindicators_org WHERE siid = $P{siid} AND orgid = $P{orgid}

[findOrgById]
SELECT * FROM subay_org_unit WHERE OrgUnitId = $P{orgid}

[getOrgUnitByParent]
SELECT * FROM subay_org_unit
WHERE (UPPER(Entity_Name) LIKE $P{searchtext} 
OR UPPER(Entity_AcronymAbbreviation) LIKE $P{searchtext})
AND ParentOrgUnitId = $P{orgparentid}
ORDER BY Entity_Name

[getSuccessIndicatorRatings]
SELECT * FROM pmis_ratings WHERE siid = $P{xxx}

[deleteSuccessIndicatorRating]
DELETE FROM pmis_ratings WHERE siid = $P{xxx}


