package kr.go.nssp.utl.egov;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.sun.xml.internal.bind.annotation.OverrideAnnotationOf;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

/**
 * EgovComAbstractDAO.java 클래스
 *
 * @author 서준식
 * @since 2011. 9. 23.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 23.   서준식        최초 생성
 * </pre>
 */
public abstract class EgovComAbstractDAO extends EgovAbstractDAO{


	@Resource(name="sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }

	@Override
	public Object selectByPk(String queryId, Object parameterObject) {
    	long startTimeMills = System.currentTimeMillis();

		Object obj = getSqlMapClientTemplate().queryForObject(queryId, parameterObject);

        return obj;
    }


    @Override
	public List list(String queryId, Object parameterObject) {
    	long startTimeMills = System.currentTimeMillis();

    	List list = getSqlMapClientTemplate().queryForList(queryId, parameterObject);

        return list;
    }


     @Override
	public List listWithPaging(String queryId, Object parameterObject, int pageIndex, int pageSize) {
        int skipResults = pageIndex * pageSize;
        ///int maxResults = (pageIndex * pageSize) + pageSize;
        int maxResults = pageSize;

    	long startTimeMills = System.currentTimeMillis();

    	List list = getSqlMapClientTemplate().queryForList(queryId, parameterObject, skipResults, maxResults);

        return list;
    }

     @Override
    public Object insert(String queryId, Object parameterObject) {
    	// TODO Auto-generated method stub
    	return super.insert(queryId, parameterObject);
    }

     @Override
    public int update(String queryId, Object parameterObject) {
    	// TODO Auto-generated method stub
    	return super.update(queryId, parameterObject);
    }

     @Override
    public int delete(String queryId, Object parameterObject) {
    	// TODO Auto-generated method stub
    	return super.delete(queryId, parameterObject);
    }
}
